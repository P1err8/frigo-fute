class Message < ApplicationRecord
  belongs_to :recipe
  # belongs_to :user, through: :recipes
end
