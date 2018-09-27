# Building a URL Shortener Rails App in 5 minutes

You probably have known about shorten URL services on the web such as bit.ly or goo.gl. It is quite handy, isn't it? Especially when you found a really great recipe web link and want to share it to your friend or just want to jot it down on your note. Imaging you could build yourself an app to convert an url such as https://www.allrecipes.com/recipe/25642/white-chocolate-raspberry-cheesecake/?internalSource=streams&referringId=387&referringContentType=Recipe%20Hub&clickId=st_recipes_mades to something a little more manageable https://bit.ly/2xQUiYn in 5 minutes! How cool is that! 

Well it is actually not 5 minutes but it is not very long in 5 steps. If you follow my instruction below, by the time finish this article. You can build yourself a brand new shorten url app which you can deploy on heroku or any platform support rails.

So let's get started!

First, we want to set some expectations from our app. So below are the deliverables:
##### Main functions: 
* A form for user to input an url 
* A show page/place to display the shorten url to user
* A copy button to let user copy and paste it to somewhere else
* The app will redirect the shorten url to original url

##### Other functions: 
* An link to create user profile and save the urls 
* An index page that shows all the links in the database belong to User
* A simple analytic shows the number of clicks from the link

#### Step 1. Create a new rails app: 
With rails, all you have to do is running the code 
`rails new short-url`
and viola you got a brand new app in a couple seconds. After the app create you got to get in its folder `cd short-url` to do the following steps.  
Since we are going to using `rails generate` or `rails g`  so if you just want to create a quick app to test things out first, you might want to slim it down. Put the following code (Jordan) to your config/application.rb 
```ruby
 config.generators do |g|
     g.test_framework false
     g.stylesheets false
     g.helper false
     g.assets false
 end
```
#### Step 2. Create Models, Migration tables and declare association relationships
* Generate model User with username attribute and create migration `users` table
`rails g model user username:string`
* Generate model Url with long_url, short_url, click atrributes and "belongs_to" association to user in migration table
`rails g model url name long_url short_url click:integer user:references`
* Next, we will need to declare association in each model:
    * Go to `app/models/user.rb` and add `has_many :urls`
    * Go to `app/models/url.rb` and add `belongs_to :urls` *(skip because rails already help us when generate with references)*
    
* Note: 
    * *if you make mistake, don't freak out you can always rollback by calling `rails d`*
    * *generate model will create 2 files in your app: `db/migrate/timestamps_create_models.rb` and `app/models/model.rb`*
#### Step 3. Check Migration and Create Database
After checking migration tables files and everything look good. We can migrate tables to our database:
`rake db:migrate` or `rails db:migrate` if you are using rails 5.
This command will create 2 files: a database file `db/development.sqlite3` and schema file `db/schema.rb`
#### Step 4. Create Views,Controllers and setup routes
 So far we have created models which are the chefs handling data from our database. Our next step is to create controllers. The controller job is to get requests from user and send response from our model to user via our views. 
 * Generate controller and views for user model:
 `rails g controller users new edit show`
 * Generate controller and views for url model:
  `rails g controller urls index new`
 Next, we want to clean up routes at /config/routes.rb by removing the generated routes with `resources`:
 ```ruby
	resources :urls, only: [:index, :new, :create, :show]
	resources :users, only: [:index, :new, :create, :show]
``` 
  Now the basic routing should work. So let check it out `rake routes` or `rails routes`
  
  We can test our brand new app now by firing our server with `rails server` or `rails s`. Go to your browser and type in '`http://localhost:3000`' should load a default rails app page. Yay! You're on Rails!! Congratulation! You can navigate to each routes and check their views. Well, they are pretty empty now but at least we know it works!
  
#### Step 5. Flesh out Controllers, Views, Helper methods and Validations
##### a. Users Controller
In our users_controller.rb file we will define all the actions that lead to corresponding views:
```ruby
class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    redirect_to user_path(@user)
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end

```
***Note**: here due to `strong params` we need to sanitize params before passing them into our model by using private method `user_params`.*

##### b. Urls Controller
Similarly, in our urls_controller.rb file we will define all the actions that lead to corresponding views in `app/views/urls`
```ruby
class UrlsController < ApplicationController

  def index
    @urls = Url.all
  end

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    @url.short_url =@url.generate_short_url
    @url.long_url = @url.sanitize
    if @url.save
      redirect_to urls_path
    else
      flash[:error] = @url.errors.full_messages
      redirect_to new_url_path
    end

  end

  def show
    @url = Url.find_by(short_url: params[:short_url])
    redirect_to @url.sanitize
  end

  private

  def url_params
    params.require(:url).permit(:name,:long_url,:user_id, :category_id)
  end
end
```
##### c. User views
We want our user to be able to create a new username and they also can see all the users in our database. 
* So first we will create a simple form for user to input their name in the view file `app/views/new.html.erb`
```html
<%= form_with model: @user do |form| %>
  <p>Please input your username: <%= form.text_field :username %></p>
  <%= form.submit %>
<% end %>
```
* Create view for each user in their show page with their short and long url along with its name
 ```html
<h2><%= @user.username %></h2>

<% @user.urls.each do |url| %>
  <ul>
    <li><%= url.name %> - <%= url.short_url %> - <%= url.long_url %></li>
  </ul>
<% end %>
```
* Create view for all users in index page with their username
```html
<% @users.each do |user| %>
  <ul>
    <li><%= link_to user.username, user_path(user) %></li>
  </ul>
<% end %>
```
##### d. Url views
* View for index page
```html
<% @urls.each do |url| %>
  <ul>
    <li><%= url.name %> - <%= link_to url.short_url, url.long_url %> - <%= url.long_url %></li>
  </ul>

<% end %>

<%= link_to 'Create another link', new_url_path %>
```
* View for new page:
```html
<h1>Urls#new</h1>
<p>Find me in app/views/urls/new.html.erb</p>
<%= flash[:error] %>
<%= form_with model: @url do |form| %>
  <p>Please input the name of the url: <%= form.text_field :name %></p>
  <p>Please input url you want to shorten: <%= form.text_field :long_url %></p>
  <p>Please select user: <%= form.collection_select :user_id, User.all, :id, :name %></p>
  <p>Please select category: <%= form.collection_select :category_id, Category.all, :id, :name %></p>
  <%= form.submit %>
<% end %>
```
For other views they are similar.
#### UrlModel:
```ruby
class Url < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates :long_url, presence: true, length: { minimum: 30}
  before_create :generate_short_url, :sanitize

  def generate_short_url
    rand(36**8).to_s(36)
  end

  def sanitize
    long_url.strip!
    sanitize_url = self.long_url.downcase.gsub(/(https?:\/\/)|(www\.)/,"")
    "http://#{sanitize_url}"
  end
end
```
Well, I am not completely finish program yet but it will be soon.