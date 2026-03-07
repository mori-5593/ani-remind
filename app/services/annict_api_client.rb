class AnnictApiClient
  BASE_URL = "https://api.annict.com"

  def initialize
    @conn = Faraday.new(url: BASE_URL) do |f|
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end
  end

  def search_works(title)
    response = @conn.get("/v1/works") do |req|
      req.params["filter_title"] = title
      req.params["access_token"] = ENV["ANNICT_ACCESS_TOKEN"]
    end

    return [] unless response.status == 200

    JSON.parse(response.body)["works"]
  end

  def fetch_work(annict_id)
    response = @conn.get("/v1/works") do |req|
      req.params["filter_ids"] = annict_id
      req.params["access_token"] = ENV["ANNICT_ACCESS_TOKEN"]
    end

    return {} unless response.status == 200

    data = JSON.parse(response.body)
    work = data["works"]&.first

    return {} unless work

    {
      title: work["title"],
      image_url: work.dig("images", "facebook", "og_image_url")
    }
  end
end
