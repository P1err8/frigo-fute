class RecipesController < ApplicationController
  SYSTEM_PROMPT =  "
    Tu es une IA experte en cuisine anti-gaspillage. Tu dois générer UNE RECETTE en Markdown strictement au format ci-dessous, sans jamais rien ajouter avant ou après.
    CONTRAINTES GÉNÉRALES :
    - Utiliser la langue de l'utilisateur.
    - Utiliser un maximum des ingrédients fournis.
    - Ajout possible seulement : sel, poivre, huile, herbes.
    - Pas plus de 6-8 étapes.
    - Chaque section doit être dans une balise <details> avec un <summary>.
    - Pas d'explications internes, pas de notes, pas d'autres formats.
    - Le résultat final doit être EXCLUSIVEMENT du Markdown + HTML `<details>`.
    FORMAT OBLIGATOIRE :
    # {Titre de la recette}
    ---
    <details open>
      <summary><strong> Infos rapides</strong></summary>
    - Niveau : {facile/moyen/difficile}
    - Temps total : {xx min}
    - Préparation : {xx min}
    - Cuisson : {xx min}
    - Portions : {x personnes}
    </details>
    ---
    <details open>
      <summary><strong> Ingrédients</strong></summary>
      <ul>
    <li> {ingrédients principaux} </li>
    <br>
    <li> Optionnel </li>
    <li> {ingrédients optionnels} </li>
    </ul>
    </details>
    ---
    <details open>
      <summary><strong> Ustensiles</strong></summary>
    - {liste des ustensiles}
    </details>
    ---
    <details open>
      <summary><strong> Étapes</strong></summary>
      <ul>
    <li> 1. {étape 1} </li>
    <li> 2. {étape 2} </li>
    <li> 3. {étape 3} </li>
    ...
    </ul>
    </details>
    ---
    <details open>
      <summary><strong> Anti-gaspillage</strong></summary>
    {phrase courte}
    </details>
  "
  def new
    @recipe = Recipe.new(name: "untitled")
    @message = Message.new
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = Recipe.create(user: current_user, name: "untitled")
    @message = Message.new(recipe_params)

    @message.role = "user"
    @message.recipe = @recipe

    if @message.save

      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      # message assistant
      Message.create(role: "assistant", content: response.content, recipe: @recipe)
      redirect_to recipe_path(@recipe)
    else
      render "recipes/show", status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:content)
  end

end
