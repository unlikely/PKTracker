STORY_UPDATE_QUEUE = Queue.new

module StoryUpdateThread
  def self.process_update_queue(options = {})
    loop do
      work = STORY_UPDATE_QUEUE.shift(options.fetch(:non_block, false))
      Story.story_update *work
    end
  rescue ThreadError
    raise unless options[:non_block]
  end
end

unless Rails.env.test?
  Thread.new do
    loop do
      begin
        StoryUpdateThread.process_update_queue
      rescue Exception => e
        Rails.logger.error "#{e.class}: #{e.message}"
        Rails.logger.info "Sleeping StoryUpdateThread for 3m and trying again..."
        sleep 180
      end
    end
  end
end
