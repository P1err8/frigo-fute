class Message < ApplicationRecord
  belongs_to :recipe
  # belongs_to :user, through: :recipes
  validates :content, presence: true
end
