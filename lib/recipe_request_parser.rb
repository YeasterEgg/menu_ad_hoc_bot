class RecipeRequestParser

  attr_accessor :message, :name, :ingredients, :course

  def initialize(message)
    @message = message
    @user = get_user
    @ingredients = message["result"]["parameters"]["ingrediente"]
    @course = message["result"]["parameters"]["portate"]
    @disjunctions = message["result"]["parameters"]["disgiunzioni"]
  end

  def get_user
    return TelegramInterface.new(@message["originalRequest"]["data"]["message"]).save_and_return
  end

  def parse
    if @ingredients.size == 0
      response = @user.no_result_response
      results = Wordpress::Post.random_recipes
    else
      response = @user.incipit_response
      results = Wordpress::Post.search_ingredients(@course, @ingredients, @disjunctions)
    end
    return results.inject(@user.incipit_response) do |text, post|
      text += "/#{post[:id]} - #{post[:title]}\n"
    end
  end

end
