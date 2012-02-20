class Story < ActiveRecord::Base
  belongs_to :owner, class_name: "Developer"

  after_create :award_points

  def award_points
    if accepted_at.present?
      owner.points_accepted += (estimate || 0.25)
      owner.save validate: false
    end
  end

  def self.story_update(project_id, story_attrs)
    if story_attrs[:current_state] == "accepted"
      project = PivotalTracker::Project.find(project_id)
      story = project.stories.find(story_attrs[:id])
      owner = Developer.find_by_tracker_name(story.owned_by)

      if owner
        create_story_for_owner owner, project, story
      end
    end
  end

  def self.create_story_for_owner(owner, project, story)
    local_story = owner.stories.find_by_tracker_id(story.id) ||
                  owner.stories.build(tracker_id: story.id)

    local_story.update_attributes! name: story.name,
                                   project: project.name,
                                   tracker_project_id: project.id,
                                   estimate: story.estimate,
                                   story_type: story.story_type,
                                   accepted_at: story.accepted_at
  end
end
