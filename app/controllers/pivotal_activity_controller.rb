class PivotalActivityController < ApplicationController
  def activity
    if params[:activity] &&
       params[:activity][:project_id] &&
       params[:activity][:event_type] == "story_update" &&
       params[:activity][:stories]

       params[:activity][:stories].each do |story_info|
         STORY_UPDATE_QUEUE.push [
           params[:activity][:project_id],
           story_info
         ]
       end
    end

    render text: "Thanks"
  end
end
