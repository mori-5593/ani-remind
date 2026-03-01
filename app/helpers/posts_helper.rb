module PostsHelper
  def render_stars(rating)
    count = rating.to_i
    stars = ([ "★" ] * count) + ([ "☆" ] * (5 - count))
    stars.map { |star| content_tag(:span, star, style: "color: #eab308;") }.join.html_safe
  end
end
