# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Category.destroy_all
Url.destroy_all

user_1= User.create(name: "Alexander")
user_2= User.create(name: "Micheal")
user_3= User.create(name: "Jordan")
user_4= User.create(name: "Morgan")

cat_1= Category.create(name: "Rails")
cat_2= Category.create(name: "Ruby")
cat_3= Category.create(name: "Sinatra")
cat_4= Category.create(name: "Cake")

# @url = Url.new
# Url.create(name: "Validation", long_url="https://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations", short_url: @url.generate_short_url, user_id: :user_1.id, category_id: :cat_1.id)
# Url.create(name: "Ruby-String", long_url="https://ruby-doc.org/core-2.2.0/String.html#method-i-split", short_url: @url.generate_short_url, user_id: :user_1.id, category_id: :cat_2.id)
# Url.create(name: "Sinatra", long_url="https://en.wikipedia.org/wiki/Sinatra_(software)", short_url: @url.generate_short_url, user_id: :user_1.id, category_id: :cat_3.id)
# Url.create(name: "Cheese Cake", long_url="https://www.allrecipes.com/recipe/236064/our-best-cheesecake/", short_url: @url.generate_short_url, user_id: :user_1.id, category_id: :cat_4.id)


