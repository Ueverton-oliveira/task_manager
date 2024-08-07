class NotificationService
  attr_reader :task

  def initialize(task)
    @task = task
  end

  def send_notification
    notification_data = {
      notification: {
        message: "Task #{@task.id} has been #{@task.persisted? ? 'updated' : 'created'}",
        received_at: Time.current,
        task_details: @task.as_json,
        user_data: {
          user_id: @task.user_id,
          user_name: User.find(@task.user_id).name
        }.as_json
      }
    }

    response = HTTParty.post("#{ENV['NOTIFICATION_SERVICE_URL']}/api/v1/notifications",
                             body: notification_data.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    if response.code == 201
      true
    else
      Rails.logger.error "Failed to send notification: #{response.body}"
      false
    end
  end
end
