class Chat < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :messages, dependent: :destroy
end
