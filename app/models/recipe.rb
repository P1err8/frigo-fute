require "open-uri"

class Recipe < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_one_attached :image

  def find_name
    doc = Nokogiri::HTML(self.content)
    title = doc.at_css("#recipe-title")&.text&.strip.sub(/\s*/, "")
  end

  def generate_and_store_picture!
    prompt = "
      Génère une image appétissante et professionnelle de ce plat culinaire.
      L'image doit être :
      - Réaliste
      - Bien éclairée avec une lumière naturelle
      - Présentée de manière appétissante sur une belle assiette
      - Avec des couleurs vives et naturelles
      - Style photographie culinaire professionnelle
      L’image doit impérativement être légère : pas de 4K, pas d’ultra HD, résolution limitée à 1024px max, poids minimal, juste une illustration simple pour interface web

      Plat à photographier : #{name}

      Ne génère que l'image du plat, sans texte ni éléments graphiques superposés.
    "

    image = RubyLLM.paint(prompt)
    file = URI.open(image.url)
    self.image.attach(
      io: file,
      filename: "image.jpg",
      content_type: "image/jpeg"
    )

  end
end
