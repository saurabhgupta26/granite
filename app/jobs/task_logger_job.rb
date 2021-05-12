class TaskLoggerJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3
  queue_as :default

  def perform(task)
    # Do something later
    log = Log.create! task_id: task.id, message: "A task was created with the following title: #{task.title}"
    puts log.message
  end

  
end
