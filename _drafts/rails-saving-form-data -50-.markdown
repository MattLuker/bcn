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
  End

  def create
    @input = Input.create(input_params)
    redirect_to inputs_path
  end

  def show
    @input = Input.find(params[:id])
    render template: "forms/#{@input.form_name}"
  end

  def update
    @input = Input.find(params[:id])
    @input.update(input_params)
    redirect_to input_path(@input)
  end

  def destroy
    Input.find(params[:id]).destroy
    redirect_to inputs_path
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

The **index** method gets all the Inputs from the database (pretty standard index method), the **create** method takes an HTTP POST parameters and creates a new Input, the **show** method looks up the Input and renders the Form template based on the *form_name* attribute, **update** does the same lookup and updates an Input via HTTP PUT/PATCH, and **destroy** deletes an Input.

A sort of unique method is the **input_params** *private* method.  Normally a *params* method is used to nonly allow certain parameters to create a new object, but in this one we’re passing a block to the **tap** method and whitelisting the **input[data]** parameters.  We need to do this in order to allow variable input fields in our Forms.  To be honest I’m not 100% sure how this code works, but I think it’s somewhat better than just not requiring the **input** parameter… somewhat.

The **Forms** controller will be much more simple, but also more custom because we’ll use a *static* HTML [erb](http://ruby-doc.org/stdlib-2.2.3/libdoc/erb/rdoc/ERB.html) template that contains the form we’re going to use to gather Input data for.

Create a **app/controllers/forms_controller.rb** file with:

```
class FormsController < ApplicationController

  def index
    forms_dir = Rails.root.join('app', 'views', 'forms')
    @forms = []

    # Get a list of form template files (just the first part of the filename)
    Dir.entries(forms_dir).each do |file|
      if (File.file?(forms_dir.to_s + '/' + file) && file != 'index.html.erb')
        @forms.push(file.split('.')[0])
      end
    end
  end

  def show
    @input = Input.new
    @input.form_name = params[:form]
    render template: "forms/#{params[:form]}"
  end
end
```

Very similar to the Inputs controller the **index** method lists each file in the **app/views/forms** directory and adds them to an array (except for index.html.erb).  The **show** method renders the form based on the **params[:form]** value.  

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
      <%= text_field_tag 'input[data][name]', @input.data.nil? ? '' : @input.data['name'], placeholder: 'Name' %>
    </div>
  </div>

  <div class="row">
    <div class="columns small-4">
      <%= text_field_tag 'input[data][address]', @input.data.nil? ? '' : @input.data['address'], placeholder: 'Address' %>
    </div>
  </div>

  <div class="row">
    <div class="columns small-4">
      <%= text_field_tag 'input[data][favorite_movie]', @input.data.nil? ? '' : @input.data['favorite_movie'],
       placeholder: 'Favorite Movie' %>
    </div>
  </div>

  <div class="row">
    <div class="columns small-4">
      <h4>Got Beef?</h4>

      <%= check_box_tag 'input[data][beef_yes]', '', @input.data.nil? ? false : @input.data['beef_yes'], id: 'input_data_beef_yes' %>
      <label for="input_data_beef_yes">Yes</label>

      &nbsp;&nbsp;&nbsp;&nbsp;

      <%= check_box_tag 'input[data][beef_no]', '', @input.data.nil? ? false : @input.data['beef_no'], id: 'input_data_beef_no' %>

      <label for="input_data_beef_no">No</label>
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

Also, feast your eyes on the [ternary](http://alvinalexander.com/blog/post/ruby/examples-ruby-ternary-operator-true-false-syntax) expressions for the value of the inputs.  If the **@input** object has a non-nil data attribute the values will be set.

Finally, create an index template for Inputs in **app/views/inputs/index.html.erb**:

```
<ul>
  <% @inputs.each do |input| %>
    <li>
      <%= link_to input.form_name, input_path(input) %> <%= input.created_at.strftime('%m:%d:%Y %H:%M:%S') %>

      &nbsp;&nbsp;&nbsp;&nbsp;
      <%= link_to 'Delete', input_path(input), method: :delete, class: 'button tiny alert' %>
    </li>
  <% end %>
</ul>

<% if @inputs.blank? %>
  <p>
    No inputs yet...
  </p>
<% end %>
```

## Conclusion

As mentioned earlier, the best thing about storing form data in a JSON object is that you can change what data is being saved by changing the form and new form data won’t conflict with old form data.  Granted if you change the **name** of the input element the Input form won’t be able to fill that field, but overall this type of system is very flexible.  

I guess that’s compare to making a form that each field corresponds to a column in a database table.  I’ve seen it done before and it was a nightmare to change fields inside a form…

Party On!