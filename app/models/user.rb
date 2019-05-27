class User < ApplicationRecord
  has_secure_password(validations: false)

  has_many :notes, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
end
