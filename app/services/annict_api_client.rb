class AnnictApiClient
  BASE_URL = "https://api.annict.com"

  def initialize
    @conn = Faraday.new(url: BASE_URL)
  end

  def search_works(title)
    response = @conn.get("/v1/works") do |req|
      req.params["filter_title"] = title
      req.params["access_token"] = ENV["ANNICT_ACCESS_TOKEN"]
    end

    return [] unless response.status == 200

    JSON.parse(response.body)["works"]
  end
end
