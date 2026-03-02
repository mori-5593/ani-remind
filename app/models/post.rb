class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }, if: -> { watched? }
  enum :status, { watched: 0, want_to_watch: 1 } # watched: みた, wat_to_watch: みたい

  def status_i18n
    case status
    when "watched" then "みた"
    when "want_to_watch" then "みたい"
    else status
    end
  end
end
