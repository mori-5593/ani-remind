module ActionsHelper
  def render_action_button(post)
    return unless current_user
    return if post.user_id == current_user.id
    return content_tag(:span, "ID未設定", class: "text-gray-400 text-sm") if post.annict_id.blank?
    annict_id = post.annict_id

    # ログイン中のユーザーがこの作品をすでに登録しているか確認
    action = current_user.actions.find_by(annict_id: annict_id)

    if action
      # 登録済みの場合：「みたい」→「みた」へ更新するボタン
      if action.want_to_watch?
        button_to "みた！", action_path(action),
        method: :patch,
        params: { my_action: { annict_id: annict_id, action_type: :watched } },
        class: "px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition"
      else
        # すでに「みた」状態なら、完了メッセージを表示
        content_tag(:span, "視聴済み", class: "px-4 py-2 bg-gray-200 text-gray-600 rounded")
      end
    else
      # 未登録の場合：「みたい」ボタンを表示
      button_to "みたい", actions_path,
      method: :post,
      params: { my_action: { annict_id: annict_id, action_type: :want_to_watch } },
      class: "px-4 py-2 bg-orange-500 text-white rounded hover:bg-orange-600 transition"
    end
  end
end
