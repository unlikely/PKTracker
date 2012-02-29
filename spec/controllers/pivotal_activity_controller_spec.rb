require 'spec_helper'

describe PivotalActivityController do
  describe "activity" do
    it "responds with ok" do
      post :activity
      response.should be_success
    end

    it "creates a story when the story has been accepted" do
      developer = Factory :developer, tracker_name: "Bob Smith"

      stories = stub "stories"
      project = stub stories: stories, id: 890890, name: "proj"
      story = stub owned_by: "Bob Smith", id: 123123,
                   name: "foo", estimate: 3,
                   story_type: "feature", accepted_at: Time.now

      PivotalTracker::Project.stub(:find).with("890890").and_return(project)
      stories.stub(:find).with("123123").and_return(story)

      post :activity, activity: {
        project_id: "890890",
        event_type: "story_update",
        stories: [
          { id: "123123",
            accepted_at: "2012/02/20 21:21:46 UTC",
            current_state: "accepted" }
        ]
      }

      STORY_UPDATE_QUEUE.should_not be_empty
      StoryUpdateThread.process_update_queue non_block: true
      STORY_UPDATE_QUEUE.should be_empty

      story = developer.reload.stories.find_by_tracker_id(123123)
      story.should_not be_nil
    end
  end
end
