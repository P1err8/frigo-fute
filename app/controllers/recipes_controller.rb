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
    - Toujours respecter STRICTEMENT le FORMAT ci-dessous ne sors jamais de cette structure.
    FORMAT OBLIGATOIRE :

    <div id='global-container'>
      <h1 id='recipe-title'> {Titre de la recette} </h1>

      <div class='dont-waste-block'>
        <summary><strong> Anti-gaspillage</strong></summary>
        <p> {phrase courte} </p>
      </div>

      <div class='short-infos-and-ustensils'>
        <details open class='infos-rapides'>
          <summary><strong> Infos rapides</strong></summary>
          <ul>
            <li> Niveau : {facile/moyen/difficile} </li>
            <li> Temps total : {xx min} </li>
            <li> Préparation : {xx min} </li>
            <li> Cuisson : {xx min} </li>
            <li> Portions : {x personnes} </li>
          </ul>
        </details>

        <details open class='ustensiles'>
          <summary><strong> Ustensiles</strong></summary>
          <ul>
            <li> {ustensiles 1} </li>
            <li> {ustensiles 2} </li>
            <li> {ustensiles 3} </li>
            <li> {ustensiles 4} </li>
            ...
          </ul>
        </details>
      </div>


      <details open class='ingredients-block'>
      <summary><strong> Ingrédients</strong></summary>
        <div class='ingredients-container'>
          <div class='ingredients-needed'>
            <summary><strong id='title-igredients-needed'> Ingrédients Obligatoire</strong></summary>
            <ul>
              <li> {ingrédients principal 1} </li>
              <li> {ingrédients principal 2} </li>
              <li> {ingrédients principal 3} </li>
              <li> {ingrédients principal 4} </li>
              ...
            </ul>
          </div>

          <div class='optional-ingredients'>
            <summary><strong id='title-igredients-optional'> Ingrédients Optionnels </strong></summary>
            <ul>
              <li> {ingrédients optionnel 1} </li>
              <li> {ingrédients optionnel 2} </li>
              <li> {ingrédients optionnel 3} </li>
              <li> {ingrédients optionnel 4} </li>
              ...
            </ul>
          </div>
        </div>

      </details>


      <details open class='etapes-block'>
        <summary><strong> Étapes</strong></summary>
        <ol>
          <li> {étape 1} </li>
          <li> {étape 2} </li>
          <li> {étape 3} </li>
          ...
        </ol>
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

      # Persist AI-generated recipe content into the Recipe record
      ai_markdown = response.content.to_s
      # Extract title from: <h1 id='recipe-title'> {Titre de la recette} </h1>
      extracted_title = begin
        # Capture inner text of the H1 with id=recipe-title
        m = ai_markdown.match(/<h1\s+id=['"]recipe-title['"]\s*>\s*(.*?)\s*<\/h1>/im)
        inner = m && m[1] ? m[1].to_s.strip : nil
        if inner
          # Remove surrounding curly braces (e.g., {Titre de la recette}) to get just the title
          inner = inner.gsub(/^\{\s*/, '').gsub(/\s*\}$/, '').strip
        end
        inner.presence
      rescue
        nil
      end

      @recipe.update(
        name: (extracted_title.presence || @recipe.name || 'untitled'),
        content: ai_markdown
      )
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
