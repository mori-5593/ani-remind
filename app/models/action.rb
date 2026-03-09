class Action < ApplicationRecord
  belongs_to :user

  enum :action_type, { watched: 0, want_to_watch: 1 }

  validates :annict_id, presence: true
  validates :user_id, uniqueness: { scope: :annict_id }
end
