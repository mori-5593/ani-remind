class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
