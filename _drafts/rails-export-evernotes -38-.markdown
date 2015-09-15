# Export Evernote Notes With Rails

## Notes The Backbone of Projects

I’ve had an [Evernote](https://www.evernote.com/referral/Registration.action?sig=ced560945d99f9c099d9282af6b8e21b&uid=11392509) account for a long time, but it wasn’t until I got a Mac and installed the desktop client that I discovered why a lot of people like Evernote.  Using the web interface from Linux workstations is one thing, but using the desktop client to keep track of ideas, projects, etc takes notes to the next level.

At least it did for me and the second biggest advantage is having access to everything on Android and iOS.

There is one big **but** though.  Having all that information in someone else’s servers and databases doesn’t always sit well.  After all everything comes to an end.  Is Evernote going to end anytime soon? I highly doubt it.  I think the Feemium model they have is great and at a price point that a lot of people don’t mind paying.  Not to mention that fact that the company is founded ran by some super smart cats.

Being such a great company Evernote has a great REST API you can use to develop on top of their platform, so we’ll whip up a Rails app to export all our precious notes so that we can back them up and maybe serve them on our own server.

## Getting Rails Setup

See this [post](http://devblog.boonecommunitynetwork.com/ruby-rails-and-passenger/) to get up and running with Ruby, Rails, and friends quickly if you don’t have a development environment already setup.

Create a new Rails project, in a terminal enter:

```

rails new rails-evernote

```

## Get Setup with Evernote

In order to integrate our Rails app with Evernote we need to get an Evernote API Key.  To do that:

* Open your browser and go to: [https://dev.evernote.com/doc/](https://dev.evernote.com/doc/).

* Click on the “Get An API Key” button in the middle of the page, or in the upper right hand corner.

* Fill out the form with your Evernote information and the information for your new Rails app.

* Copy and paste, or save however you like (maybe in an Evernote note?), the **Consumer Key** and **Consumer Secret**.

With all the “paper” work filled out, if you scroll further down on the page you’ll see a table listing the Evernote SDK for various languages.  The one we’re looking for, obviously huh huh huh, is for [Ruby](https://github.com/evernote/evernote-sdk-ruby).

Go ahead and install these gems:

```

gem install https://github.com/evernote/evernote-oauth-ruby/tree/master/sample/ruby_on_rails

```

## Evernote and Rails

Now let’s setup our Rails project to use the Evernote API.  Evernote has a good [example Rails app](https://github.com/evernote/evernote-oauth-ruby/tree/master/sample/ruby_on_rails) that we’ll borrow a lot from.

### Gemfile

Add the following to your **Gemfile**:

```

gem 'evernote_oauth'

gem 'foundation-rails'

```

And install the gems:

```

bundle install

```

### OAuth to Evernote

Create a new config file for our Evernote key and secret in **config/evernote.yml** with the following:

```

development:

  consumer_key: ‘YOUR_KEY’

  consumer_secret: ‘YOUR_SECRET’

```

Next, create a config initializer in **config/initializers/evernote.rb** with:

```

EVERNOTE_CONFIG = Rails.application.config_for(:evernote)

```

### Controller

To authenticate with Evernote via OAuth add the following method to the **app/controllers/application_controller.rb** file:

```

  def '/evernote_auth'

    callback_url = '/evernote_auth/callback'

    begin

      consumer = OAuth::Consumer.new(EVERNOTE_CONFIG['consumer_key'], EVERNOTE_CONFIG['consumer_secret'],{

        :site => EVERNOTE_SERVER,

        :request_token_path => "/oauth",

        :access_token_path => "/oauth",

        :authorize_path => "/OAuth.action"})

        session[:request_token] = consumer.get_request_token(:oauth_callback => callback_url)

        @current_status = "Obtained temporary credentials"

    rescue => e

      @last_error = "Error obtaining temporary credentials: #{e.message}"

    end

    if @current_status

      flash[:success] = @current_status

    else

      flash[:alert] = @last_error

    end

    redirect_to root_path

  end

```

Time to setup the *Notes* controller.  Create a new file **app/controllers/notes_controller.rb** and for now put:

```

class NotesController < ApplicationController

  def index

  end

  def show

  end

  

end

```

### Add Some Routy Routes

Open the **config/routes.rb** file and add:

```

```