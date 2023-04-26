require_relative 'lib/recipe_repository'
require_relative 'lib/database_connection'

DatabaseConnection.connect('recipes_directory')

recipe_repository = RecipeRepository.new

recipe = recipe_repository.all.each do |recipe|
  puts recipe.title
end