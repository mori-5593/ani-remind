module ActionsHelper
  def render_action_button(object)
    return unless current_user

    if object.is_a?(Post)
      if object.user_id == current_user.id
        if object.want_to_watch?
          return turbo_frame_tag "action_button_#{object.annict_id}" do
            link_to(
              "感想を書く",
              new_post_path(annict_id: object.annict_id, from: "mypage"),
              data: { turbo: false },
              class: "text-xs px-2 py-2 bg-emerald-500 text-white rounded hover:bg-emerald-600 transition"
            )
          end 
        else
          return nil
        end
      end

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

    # Turbo Frameで囲むことで、この部分だけを書き換え可能にする
    turbo_frame_tag "action_button_#{annict_id}" do
      if Post.exists?(user_id: current_user.id, annict_id: annict_id)
        link_to "投稿済み", "#", class: "text-xs px-2 py-2 bg-gray-400 rounded text-white cursor-not-allowed"
      elsif action&.persisted?
        link_to(
          "感想を書く",
          new_post_path(annict_id: annict_id, from: "mypage"),
          data: { turbo: false },
          class: "text-xs px-2 py-2 bg-emerald-500 text-white rounded hover:bg-emerald-600 transition"
        )
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
end
