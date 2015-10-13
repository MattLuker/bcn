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

Grab the Foundation gems to make things look good by adding the following to the project’s **Gemfile**:

```

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

      t.string :form_path

      t.json :data

    end

```

Run the migration:

```

bin/rake db:migrate

```

Whip up a simple model in **app/models/input.rb** with:

```

class Input < ActiveRecord::Base

end

```