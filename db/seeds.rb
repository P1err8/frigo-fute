# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "Cleaning database..."
Recipe.destroy_all
User.destroy_all
puts "Done."

user = User.create!(
  username: "demo",
  email: "demo@frigo_fute.com",
  password: "Secret42"
)


recipe_markdown = <<~MARKDOWN
  # 🍝 Pâtes sautées à la viande hachée et œuf

  ---

  <details open>
    <summary><strong>📌 Infos rapides</strong></summary>

  - Niveau : facile
  - Temps total : 20 min
  - Préparation : 10 min
  - Cuisson : 10 min
  - Portions : 2 personnes

  </details>

  ---

  <details open>
    <summary><strong>🥣 Ingrédients</strong></summary>

  ### Base
  - 200 g de pâtes
  - 150 g de viande hachée
  - 1 œuf

  ### Optionnel
  - 1 oignon
  - 1 c. à soupe d’huile
  - Sel, poivre
  - Herbes séchées

  </details>

  ---

  <details open>
    <summary><strong>🔧 Ustensiles</strong></summary>

  - Casserole
  - Poêle
  - Passoire
  - Spatule

  </details>

  ---

  <details open>
    <summary><strong>👨‍🍳 Étapes</strong></summary>

  1. Cuire les pâtes dans l’eau salée, égoutter.
  2. Chauffer l’huile, cuire la viande, assaisonner.
  3. Ajouter l’oignon émincé, cuire 2 min.
  4. Ajouter les pâtes, mélanger.
  5. Casser l’œuf, mélanger rapidement.
  6. Cuire 1 min, ajouter les herbes, servir.

  </details>

  ---

  <details open>
    <summary><strong>♻️ Anti-gaspillage</strong></summary>

  Utilise un œuf seul, un petit reste de viande et un paquet de pâtes déjà ouvert.

  </details>
MARKDOWN

puts "Creating seed recipe..."

recipe = Recipe.create!(
  name: "Pâtes sautées à la viande hachée et œuf",
  content: recipe_markdown,
  user: user
)

puts "Created recipe ##{recipe.id}"
