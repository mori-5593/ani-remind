module ActionsHelper
  def render_action_button(object)
    return unless current_user
    
    # 1. PostかActionかを判定してデータを取得
    if object.is_a?(Post)
      return if object.user_id == current_user.id # 自分の投稿にはボタン不要
      return content_tag(:span, "ID未設定", class: "text-gray-400 text-sm") if object.annict_id.blank?
      
      annict_id = object.annict_id
      action = current_user.actions.find_by(annict_id: annict_id)
      title = object.title
      image_url = object.image_url
    else
      # objectがActionの場合（マイページ用）
      annict_id = object.annict_id
      action = object # object自体がアクションなのでそのまま使う
      title = object.title
      image_url = object.image_url
    end

    if action&.persisted?
      if action.want_to_watch?
        link_to "感想を書く", new_post_path(annict_id: annict_id),
          class: "px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition"
      else
        link_to "感想を書く", new_post_path(annict_id: annict_id),
          class: "px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition"
      end
    else
      # 未登録の場合：「みたい」ボタン
      button_to "みたい", actions_path,
        method: :post,
        params: { 
          my_action: { annict_id: annict_id, action_type: :want_to_watch, title: title, image_url: image_url } 
        },
        class: "px-4 py-2 bg-orange-500 text-white rounded hover:bg-orange-600 transition"
    end
  end
end