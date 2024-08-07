require 'httparty'

class ScrapedDataFetcher
  include HTTParty

  def initialize(task_id)
    @task_id = task_id
  end

  def fetch_data
    response = self.class.get("#{ENV['WEB_SCRAPING_SERVICE_URL']}/api/v1/tasks/#{@task_id}/scraped_data")
    if response.success?
      JSON.parse(response.body)
    else
      []
    end
  end
end

