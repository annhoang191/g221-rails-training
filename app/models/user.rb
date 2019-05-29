class User < ApplicationRecord
  has_secure_password

  has_many :notes, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups

  validates :email, presence: true, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :name, presence: true

  def self.cache_current_user(user_id)
    current_time = Time.zone.now
    Rails.cache.fetch("user#{user_id}-#{current_time.to_i}", expires_in: 1.hours) do
      find(user_id)
    end
  end
end
