class ActionsController < ApplicationController
  # before_action :authenticate_user!

  # 「みたい」に追加
  def create
    @action = current_user.actions.build(action_params)

    if @action.save
      # redirect_back fallback_location: root_pathは直前のページへリダイレクトされる
      redirect_back fallback_location: root_path, notice: "リストに追加しました"
    else
      redirect_back fallback_location: root_path, alert: "追加に失敗しました"
    end
  end

  # 「みたい」→「みた」に変更
  def update
    @action = current_user.actions.find_by!(annict_id: params[:action][:annict_id])

    if @action.update(action_params)
      redirect_back fallback_location: root_path, notice: "視聴状況を更新しました"
    else
      redirect_back fallback_location: root_path, alert: "更新に失敗しました"
    end
  end

  private

  def action_params
    params.require(:my_action).permit(:annict_id, :action_type)
  end
end
