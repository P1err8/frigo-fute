class Recipe < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  def find_name
    doc = Nokogiri::HTML(self.content)
    title = doc.at_css("#recipe-title")&.text&.strip.sub(/\s*/, "")
  end

end
