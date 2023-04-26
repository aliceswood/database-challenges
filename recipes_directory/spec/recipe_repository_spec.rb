require 'recipe_repository'

RSpec.describe RecipeRepository do
  def reset_recipes_table
    seed_sql = File.read('spec/seeds_recipes.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'recipes_directory_test' })
    connection.exec(seed_sql)
  end

  describe RecipeRepository do
    before(:each) do 
      reset_recipes_table
    end
  end

  it 'returns a list of recipes' do
    repo = RecipeRepository.new

    recipe = repo.all
    expect(recipe.length).to eq(2) # =>  2
    expect(recipe.first.id).to eq('1') # => 1
    expect(recipe.first.title).to eq('Enchiladas')
    expect(recipe.first.cooking_time).to eq('45')
    expect(recipe.first.rating).to eq('5')
  end

  it 'returns Enchiladas' do
    repo = RecipeRepository.new

    recipe = repo.find(1)
    expect(recipe.id).to eq('1')
    expect(recipe.title).to eq('Enchiladas')
    expect(recipe.cooking_time).to eq('45')
    expect(recipe.rating).to eq('5')
  end

  it 'returns Chicken Curry' do
    repo = RecipeRepository.new

    recipe = repo.find(2)
    expect(recipe.id).to eq('2')
    expect(recipe.title).to eq('Chicken Curry')
    expect(recipe.cooking_time).to eq('30')
    expect(recipe.rating).to eq('4')
  end
end