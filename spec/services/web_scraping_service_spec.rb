require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WebScrapingService do
  let(:url) { 'http://example.com' }
  let(:web_scraping_service_url) { 'http://webscraping.example.com' }
  let(:service) { described_class.new(url) }

  before do
    stub_const('ENV', ENV.to_hash.merge('WEB_SCRAPING_SERVICE_URL' => web_scraping_service_url))
  end

  describe '#scrape' do
    context 'when the response is successful' do
      before do
        stub_request(:post, "#{web_scraping_service_url}/api/v1/scrape")
          .with(
            body: { url: url }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 200, body: '', headers: {})
      end

      it 'sends a post request to the web scraping service' do
        expect(Rails.logger).not_to receive(:error)
        service.scrape
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, "#{web_scraping_service_url}/api/v1/scrape")
          .with(
            body: { url: url }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 500, body: 'Internal Server Error', headers: {})
      end

      it 'logs an error message' do
        expect(Rails.logger).to receive(:error).with('Failed to initiate scraping: Internal Server Error')
        service.scrape
      end
    end
  end
end
