module ActionsHelper
  def render_action_button(object)
    return unless current_user

    if object.is_a?(Post)
      return if object.user_id == current_user.id
      return content_tag(:span, "ID未設定", class: "text-gray-400 text-sm") if object.annict_id.blank?

      annict_id = object.annict_id
      action = current_user.actions.find_by(annict_id: annict_id)
      title = object.title
      image_url = object.image_url
    else
      # objectがActionの場合（マイページ用）
      annict_id = object.annict_id
      action = object
      title = object.title
      image_url = object.image_url
    end

    if Post.exists?(user_id: current_user.id, annict_id: annict_id)
      link_to "投稿済み", "#", class: "text-xs px-2 py-2 bg-gray-400 rounded text-white cursor-not-allowed"
    elsif action&.persisted?
      if action.want_to_watch?
        link_to "感想を書く", new_post_path(annict_id: annict_id),
          class: "text-xs px-2 py-2 bg-emerald-500 text-white rounded hover:bg-emerald-600 transition"
      else
        link_to "感想を書く", new_post_path(annict_id: annict_id),
          class: "text-xs px-2 py-2 bg-emerald-500 text-white rounded hover:bg-emerald-600 transition"
      end
    else
      # 未登録の場合：「みたい」ボタン
      button_to "みたい", actions_path,
        method: :post,
        params: {
          my_action: { annict_id: annict_id, action_type: :want_to_watch, title: title, image_url: image_url }
        },
        class: "text-xs px-2 py-2 bg-orange-500 text-white rounded hover:bg-orange-600 transition"
    end
  end
end
