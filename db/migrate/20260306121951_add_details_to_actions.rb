class AddDetailsToActions < ActiveRecord::Migration[8.1]
  def change
    add_column :actions, :title, :string
    add_column :actions, :image_url, :string
  end
end
