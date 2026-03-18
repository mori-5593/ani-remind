class User < ApplicationRecord
  has_secure_password
  has_many :actions, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  # allow_nilはpassword属性がnilの場合バリデーションエラーが発生しない、
  # 空文字の場合適応されずpresence: trueによるバリデーションエラーが発生する
  # 値がある場合presence: trueによるバリデーションエラーが発生しない
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
