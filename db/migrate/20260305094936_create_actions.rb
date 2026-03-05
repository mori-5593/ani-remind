class CreateActions < ActiveRecord::Migration[8.1]
  def change
    create_table :actions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :annict_id, null: false
      t.integer :action_type, default: 0, null: false #0:みた, 1:みたい

      t.timestamps
    end

    # 同じユーザーが同じ作品を重複して登録できないように制限
    add_index :actions, [:user_id, :annict_id], unique: true
  end
end
