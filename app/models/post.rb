class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
  enum :status, { watched: 0, want_to_watch: 1 } #watched: みた, wat_to_watch: みたい
end
