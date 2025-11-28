class Message < ApplicationRecord
  belongs_to :recipe
  # belongs_to :user, through: :recipes
  validates :content, presence: true
  after_save :update_recipe

  def update_recipe
    return unless self.role == "assistant"
    self.recipe.update(content: self.content)
    self.recipe.update(name: self.recipe.find_name || "untitled")
  end
end
