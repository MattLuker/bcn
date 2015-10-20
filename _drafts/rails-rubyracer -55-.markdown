# Rails CoffeeScript, and The Ruby Racer

## Ruby Objects in JavaScrip

It’s very tempting to create JavaScript, or CoffeeScript, files as **erb** templates and inject (I think that’s the right term in this situation) Ruby code from the server into the client side files.  I know it’s frowned upon by the larger Ruby community, but that being the case there is cool projects like [therubyracer](https://github.com/cowboyd/therubyracer) out there.

Also, the default scaffolding for a Rails app comes with **therubyracer** gem in the Gemfile.  Though it is commented by default.

This makes me feel that using therubyracer, or similar Ruby object injectors, is a more advanced feature of Rails.  Let’s explore the possibilities and see what we can break…

## Rails Project

There is no hoops to jump through this time to get access to an API, so go ahead and create a new Rails project.  In a terminal enter:

```
rails new rails-racer
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
