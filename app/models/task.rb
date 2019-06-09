class Task < ApplicationRecord
  belongs_to :user

  enum status: %i[unset not_done done]

  validates :content, presence: true
end
