class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false # タイトル必須
      t.text :content
      t.integer :rating, null: false, default: 0 # 評価は必須、デフォルト０
      t.integer :annict_id
      t.string :image_url

      t.timestamps
    end
  end
end
