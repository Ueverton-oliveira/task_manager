class WebScrapingService
  attr_reader :url
  def initialize(url)
    @url = url
  end

  def scrape
    response = HTTParty.post("#{ENV['WEB_SCRAPING_SERVICE_URL']}/api/v1/scrape",
                             body: { url: @url }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    unless response.code == 200
      Rails.logger.error "Failed to initiate scraping: #{response.body}"
    end
  end
end
