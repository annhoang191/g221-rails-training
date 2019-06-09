class Note < ApplicationRecord
  belongs_to :user

  validates :content, presence: true

  scope :order_id, -> { order(id: :desc) }
end
