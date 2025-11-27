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
    <div id='global-container'>
      # {Titre de la recette}
      ---
      <details open class='infos-block'>
        <summary><strong> Infos rapides</strong></summary>
      <ul>
        <li> Niveau : {facile/moyen/difficile} </li>
        <li> Temps total : {xx min} </li>
        <li> Préparation : {xx min} </li>
        <li> Cuisson : {xx min} </li>
        <li> Portions : {x personnes} </li>
      </ul>
      </details>
      ---
      <details open class='infos-block'>
      <summary><strong> Ingrédients</strong></summary>
        <ul>
      <li> {ingrédients principal 1} </li>
      <li> {ingrédients principal 2} </li>
      <li> {ingrédients principal 3} </li>
      ...
      <li> Optionnel </li>
      <li> {ingrédients optionnel 1} </li>
      <li> {ingrédients optionnel 2} </li>
      ...
      </ul>
      </details>
      ---
      <details open class='infos-block'>
        <summary><strong> Ustensiles</strong></summary>
        <ul>
          <li> {liste des ustensiles} </li>
        </ul>
      </details>
      ---
      <details open class='infos-block'>
        <summary><strong> Étapes</strong></summary>
        <ul>
      <li> 1. {étape 1} </li>
      <li> 2. {étape 2} </li>
      <li> 3. {étape 3} </li>
      ...
      </ul>
      </details>
      ---
      <details open class='dont-waste-block'>
        <summary><strong> Anti-gaspillage</strong></summary>
      {phrase courte}
      </details>
    </div>
  "
  def index
    @recipes = current_user.recipes
  end

  def new
    @recipe = Recipe.new(name: "untitled")
    @message = Message.new
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def create
    # reprende ça plus tard (je prend une recette si LLM down ?)
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
      render "recipes/new", status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:content)
  end

end
