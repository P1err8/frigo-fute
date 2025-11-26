class RecipesController < ApplicationController
  def new
    @recipe = Recipe.new
  end

  def show
    @recipe = Recipe.find(params[:recipe_id])
  end

  def create
    raise
    @recipe = Recipe.find(params[:recipe_id])

    # message user
    @message = Message.new(recipe_params)

    if @message.save

      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      # message assistant
      Message.create(role: "assistant", content: response.content)

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
