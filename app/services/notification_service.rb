class NotificationService
  def self.send_notification(task, action)
    response = HTTParty.post("#{ENV['NOTIFICATION_SERVICE_URL']}/api/v1/notifications",
                             body: {
                               task_id: task.id,
                               task_title: task.name,
                               task_status: task.status,
                               user_id: task.user_id,
                               action: action
                             }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    unless response.code == 201
      Rails.logger.error "Failed to send notification: #{response.body}"
    end
  end
end
