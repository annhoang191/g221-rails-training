class User < ApplicationRecord
  has_secure_password

  has_many :notes, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups

  validates :email, presence: true, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :name, presence: true
end
