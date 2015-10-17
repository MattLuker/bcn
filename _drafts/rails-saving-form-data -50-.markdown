# Rails Saving Form Data

## HTML Forms

The main way that information is collected on the web is through HTML form elements.  This could be the bane of my existence…

The process is pretty straight forward.  You have a form tag and inside that there are a bunch of input elements where the site user can enter data.  There are a variety of different input elements from text fields to check boxes.  Drop downs and select lists are included.

We’re going to setup a Rails project to serve an HTML form from an **erb** template then save the data into a [PostgreSQL JSON](http://www.postgresql.org/docs/9.3/static/functions-json.html) column.  Using a JSON column will allow the HTML form to change over time and new fields will be automatically saved, and if there are fields taken away they just won’t show up in the new form even though the data will be there.

## Rails Project

There is no hoops to jump through this time to get access to an API, so go ahead and create a new Rails project.  In a terminal enter:

```
rails new rails-forms
```

Name your project as you’d like.  Also, to get Ruby and Rails setup see [this post](http://devblog.boonecommunitynetwork.com/ruby-rails-and-passenger/).

### Gems

Grab the Foundation, and pg, gems to make things look good by adding the following to the project’s **Gemfile**:

```
gem ‘pg’
gem 'foundation-rails'
gem 'foundation-icons-sass-rails'
```

Now setup Foundation and install any additional gems:

```
rails g foundation:install
bundle install
```

## Routes

The routes are pretty simple for this app.  Edit **config/routes.rb** and add the following:

```
  root ‘forms#index'
  resources :inputs
```

The **index** method of the Forms controller will be the root, or index, route and using **resources** to take care of the routes for the Inputs model.  We’ll use Inputs to store the data that is *inputted* to the form.

## Models

Create a **Input** model, and corresponding **inputs** table, with a migration:

```
bin/rails g migration create_inputs
```

Add the following to the **change** method in the **db/migrate/$DATE_create_feeds.rb** file:

```
    create_table :inputs do |t|
      t.string :form_name
      t.json :data
      t.timestamps null: false
    end
```

Adjust the **config/database.yml** to use PostgreSQL with these edits:

```
default: &default
  adapter: postgresql
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: forms_dev

test:
  <<: *default
  database: forms_test

production:
  <<: *default
  database: forms
```

We won’t be using the **test** and **production** databases in this post, but they’re good to have just in case.  It’s also good to know that the configs will be there when you do need them.

Run the migration:

```
bin/rake db:create
bin/rake db:migrate
```

Whip up a simple model in **app/models/input.rb** with:

```
class Input < ActiveRecord::Base
end
```

## Controllers

This controller takes advantage of Rails [resources](http://guides.rubyonrails.org/routing.html#resource-routing-the-rails-default) there are some methods for CRUD operations.

```
class InputsController < ApplicationController
  def index
    @inputs = Input.all
  end

  def new
    @input = Input.new
  end

  def create
    @input = Input.create(input_params)
    redirect_to root_path
  end

  def edit
    @input = Input.find(params[:id])
  end

  def update
    @input = Input.find(params[:id])
    @Input.update(input_params)
    redirect_to root_path
  end

  def show
    @input = Input.find(params[:id])

    respond_to do |format|
      format.html { render template: "forms/#{@input.form_name}" }
      format.json { render :show }
    end
  end

  private
    def input_params
      params.require(:input).permit(:form_name, data: {})
      params.require(:input).permit(:form_name, data: {}).tap do |whitelisted|
        whitelisted[:data] = params[:input][:data]
      end
    end
end
```

Here’s a quick explanation of the controller methods:

TK

The **Forms** controller will be much more simple, but also more custom because we’ll use a *static* HTML [erb](http://ruby-doc.org/stdlib-2.2.3/libdoc/erb/rdoc/ERB.html) template that contains the form we’re going to use to gather Input data for.

Create a **app/controllers/forms_controller.rb** file with:

```
```

## Views

First off let’s adjust the base layout template in **app/views/layouts/application.html.erb** replace the contents of the **body** tag with:

```
    <div class="row">
      <div class="columns small-12">
        <dl class="sub-nav">
          <dd class="<%= 'active' if params[:controller] == 'forms' %>"><a href="/">Forms</a></dd>
          <dd class="<%= 'active' if params[:controller] == 'inputs' %>"><a href="/inputs">Inputs</a></dd>
        </dl>

        <%= yield %>

        <br/>
      </div>
    </div>
```

This will setup a [Foundation Sub Nav](http://foundation.zurb.com/docs/components/subnav.html) with links to the Forms and Inputs index pages.

Next, create a directories for the forms and inputs **app/views**.  So you should now have the **app/views/inputs** and **app/views/forms** directories.

Now create the **app/views/forms/index.html.erb** file containing:

```
<% if @forms.blank? %>
  <p>
    No forms yet...
  </p>
  <p>
    Create form templates in <em>app/views/forms</em>.
  </p>
<% end %>

<ul>
  <% @forms.each do |form| %>
    <li>
      <%= link_to form, "/forms/#{form}" %>
    </li>
  <% end %>
</ul>
```

Also, inside the **app/views/forms** directory create the first form template named **test.html.erb**:

```
<h2>Test Form</h2>

<%= form_for @input do |f| %>

  <div class="row">
    <div class="columns small-4">
      <%= text_field_tag 'input[data][name]', '', placeholder: 'Name' %>
    </div>
  </div>

  <div class="row">
    <div class="columns small-4">
      <%= text_field_tag 'input[data][address]', '', placeholder: 'Address' %>
    </div>
  </div>

  <div class="row">
    <div class="columns small-4">
      <%= text_field_tag 'input[data][favorite_movie]', '', placeholder: 'Favorite Movie' %>
    </div>
  </div>

  <div class="row">
    <div class="columns small-4">
      <%= submit_tag 'Save Form', class: 'button small' %>
    </div>
  </div>

  <%= hidden_field_tag 'input[form_name]', @input.form_name %>
<% end %>
```

Notice the hidden field tag at the end for **input[form_name]** this is really the only **required** field because it sets the Input objects **form_name** attribute (in case that wasn’t obvious) you can add whatever other kind of input elements you’d like.

We use the same Form template file to display the empty form and again in the Inputs controller to display an Input form.  Pretty clever huh?

## CoffeeScript

It’s not very useful to only display the same form for Inputs if it’s just going to be blank.  
