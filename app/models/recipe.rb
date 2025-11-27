class Recipe < ApplicationRecord
  belongs_to :user
  has_many :messages

  MARKDOWN = "<<~MARKDOWN
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
    - 1 c. à soupe d'huile
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

    1. Cuire les pâtes dans l'eau salée, égoutter.
    2. Chauffer l'huile, cuire la viande, assaisonner.
    3. Ajouter l'oignon émincé, cuire 2 min.
    4. Ajouter les pâtes, mélanger.
    5. Casser l'œuf, mélanger rapidement.
    6. Cuire 1 min, ajouter les herbes, servir.

    </details>

    ---

    <details open>
      <summary><strong>♻️ Anti-gaspillage</strong></summary>

    Utilise un œuf seul, un petit reste de viande et un paquet de pâtes déjà ouvert.

    </details>
  MARKDOWN"
end
