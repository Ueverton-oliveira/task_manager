class WebScrapingService

  def self.scrape(url)
    response = HTTParty.post("#{ENV['WEB_SCRAPING_SERVICE_URL']}/api/v1/scrape",
                             body: { url: url }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    unless response.code == 200
      Rails.logger.error "Failed to initiate scraping: #{response.body}"
    end
  end
end
