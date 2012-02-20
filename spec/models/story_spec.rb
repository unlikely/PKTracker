require 'spec_helper'

describe Story do
  describe "story_update" do
    let(:project_id) { "890890" }
    let(:story_id) { "123123" }

    let(:story) do
      stub owned_by: "Bob Smith",
           id: story_id,
           name: "Story Name",
           estimate: 2,
           story_type: "feature",
           accepted_at: Time.now
    end

    let(:stories) { stub "stories" }

    let(:project) do
      project = stub stories: stories,
                     id: project_id,
                     name: "Project Name"
    end

    before do

      PivotalTracker::Project.stub(:find).with(project_id).and_return(project)
      stories.stub(:find).with(story_id).and_return(story)
    end

    it "creates a story for owner when accepted" do
      owner = Factory :developer, tracker_name: "Bob Smith"
      Story.story_update project_id, id: story_id,
                                     current_state: "accepted"

      story = owner.reload.stories.find_by_tracker_id(story_id)
      story.should_not be_nil
    end

    it "doesn't create a story if not accepted" do
      owner = Factory :developer, tracker_name: "Bob Smith"
      Story.story_update project_id, id: story_id,
                                     current_state: "foobar"

      owner.reload.should have(0).stories
    end

    it "doesn't create a story if one already exists" do
      owner = Factory :developer, tracker_name: "Bob Smith"
      Story.story_update project_id, id: story_id,
                                     current_state: "accepted"
      Story.story_update project_id, id: story_id,
                                     current_state: "accepted"

      owner.reload.should have(1).stories
    end

    it "captures pertinent details from tracker" do
      owner = Factory :developer, tracker_name: "Bob Smith"
      Story.story_update project_id, id: story_id,
                                     current_state: "accepted"

      s = owner.reload.stories.find_by_tracker_id(story_id)
      s.name.should == story.name
      s.project.should == project.name
      s.tracker_project_id.should == project.id.to_i
      s.estimate.should == story.estimate
      s.story_type.should == story.story_type
      s.accepted_at.should == story.accepted_at
    end

    it "doesn't create a story if no developer is found" do
      -> do
        Story.story_update project_id, id: story_id,
                                       current_state: "accepted"
      end.should_not change(Story, :count)
    end
  end

  describe "Updating points accepted on owner" do
    it "does so based on estimate on create" do
      owner = Factory :developer, points_accepted: 3
      owner.stories.create! Factory.attributes_for(:story,
                                                   estimate: 2,
                                                   accepted_at: Time.now)
      owner.reload.points_accepted.should == 5
    end

    it "awards a quarter point if estimate is nil" do
      owner = Factory :developer, points_accepted: 3
      owner.stories.create! Factory.attributes_for(:story,
                                                   estimate: nil,
                                                   accepted_at: Time.now)
      owner.reload.points_accepted.should == 3.25
    end

    it "doesn't award points if accepted_at is nil" do
      owner = Factory :developer, points_accepted: 3
      owner.stories.create! Factory.attributes_for(:story,
                                                   estimate: 2,
                                                   accepted_at: nil)
      owner.reload.points_accepted.should == 3
    end

    it "doesn't award points on updating story" do
      owner = Factory :developer, points_accepted: 3
      story = owner.stories.create! Factory.attributes_for(:story,
                                                           estimate: 2,
                                                           accepted_at: Time.now)
      story.update_attributes estimate: 1
      owner.reload.points_accepted.should == 5
    end
  end
end
