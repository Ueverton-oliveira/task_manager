require 'rails_helper'
require 'webmock/rspec'

RSpec.describe NotificationService, type: :service do
  let(:task) { create(:task) }
  let(:notification_service) { NotificationService.new(task) }

  describe '#send_notification' do
    before do
      stub_request(:post, "#{ENV['NOTIFICATION_SERVICE_URL']}/api/v1/notifications")
        .to_return(status: 201, body: "", headers: {})
    end

    it 'sends a notification successfully' do
      expect(notification_service.send_notification).to be_truthy
    end

    it 'logs an error if notification fails' do
      allow(Rails.logger).to receive(:error)
      stub_request(:post, "#{ENV['NOTIFICATION_SERVICE_URL']}/api/v1/notifications")
        .to_return(status: 500, body: "", headers: {})

      notification_service.send_notification
      expect(Rails.logger).to have_received(:error).with("Failed to send notification: ")
    end
  end
end
