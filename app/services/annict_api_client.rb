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

    works = JSON.parse(response.body)["works"]

    # プロキシ処理を適用
    works.each do |work|
      if work["images"]
        work["images"]["facebook"]["og_image_url"] = format_image_url(work.dig("images", "facebook", "og_image_url"))
        work["images"]["recommended_url"] = format_image_url(work.dig("images", "recommended_url"))
        work["images"]["twitter"]["original_avatar_url"] = format_image_url(work.dig("images", "twitter", "original_avatar_url"))
      end
    end

    works
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

    raw_url = work.dig("images", "facebook", "og_image_url").presence ||
              work.dig("images", "recommended_url").presence ||
              work.dig("images", "twitter", "original_avatar_url").presence

    {
      title: work["title"],
      image_url: format_image_url(raw_url)
    }
  end

  private

  def format_image_url(url)
    return nil if url.blank?

    # image.annict.com の証明書エラー対策としてプロキシを経由させる
    if url.include?("image.annict.com")
      # weserv.nl プロキシを使用（httpでアクセスして証明書エラーを回避し、プロキシ側でhttps化する）
      return "https://images.weserv.nl/?url=#{url.gsub("https://", "http://")}"
    end

    # http の場合は https に変換（Mixed Content対策）
    url.gsub(/^http:\/\//, "https://")
  end
end
