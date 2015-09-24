# Export Evernote Notes With Rails

## Notes The Backbone of Projects

I’ve had an [Evernote](https://www.evernote.com/referral/Registration.action?sig=ced560945d99f9c099d9282af6b8e21b&uid=11392509) account for a long time, but it wasn’t until I got a Mac and installed the desktop client that I discovered why a lot of people like Evernote.  Using the web interface from Linux workstations is one thing, but using the desktop client to keep track of ideas, projects, etc takes notes to the next level.

At least it did for me and the second biggest advantage is having access to everything on Android and iOS.

There is one big **but** though.  Having all that information in someone else’s servers and databases doesn’t always sit well.  After all everything comes to an end.  Is Evernote going to end anytime soon? I highly doubt it.  I think the Feemium model they have is great and at a price point that a lot of people don’t mind paying.  Not to mention that fact that the company is founded ran by some super smart cats.

Being such a great company Evernote has a great REST API you can use to develop on top of their platform, so we’ll whip up a Rails app to export all our precious notes so that we can back them up and maybe serve them on our own server.

## Get Setup with Evernote

In order to integrate our Rails app with Evernote we need to get an Evernote API Key.  To do that:

* Open your browser and go to: [https://dev.evernote.com/doc/](https://dev.evernote.com/doc/).

* Click on the “Get An API Key” button in the middle of the page, or in the upper right hand corner.

* Fill out the form with your Evernote information and the information for your new Rails app.

* Select **Full Access** in the “API Permissions” box because this will allow you to view Note content.

* Copy and paste, or save however you like (maybe in an Evernote note?), the **Consumer Key** and **Consumer Secret**.

With all the “paper” work filled out, if you scroll further down on the page you’ll see a table listing the Evernote SDK for various languages.  The one we’re looking for, obviously huh huh huh, is for [Ruby](https://github.com/evernote/evernote-sdk-ruby).

## Evernote and Rails

### Start the Project

See this [post](http://devblog.boonecommunitynetwork.com/ruby-rails-and-passenger/) to get up and running with Ruby, Rails, and friends quickly if you don’t have a development environment already setup.

Create a new Rails project, in a terminal enter:

```

rails new rails-evernote

```

Add the needed gems to **Gemfile**:

```

gem 'evernote_oauth'

gem 'nokogiri'

gem 'foundation-rails'

gem 'foundation-icons-sass-rails'

```

Okay, so they  may all not be “**needed**” for the app to work, but the Foundation gems really do make things look good. Setup Foundation with:

```

rails g foundation:install

```

And install the gems:

```

bundle install

```

### OAuth to Evernote

Create a new config file for our Evernote key and secret in **config/evernote.yml** with the following:

```

development:

  evernote_server: 'https://sandbox.evernote.com'

  consumer_key: ‘YOUR_KEY’

  consumer_secret: ‘YOUR_SECRET’

```

Next, create a config initializer in **config/initializers/evernote.rb** with:

```

EVERNOTE_CONFIG = Rails.application.config_for(:evernote)

```

One more setup thing we need to add is setup a session **cache_store** to save our OAuth tokens from Evernote.  Add the following to the end of **config/initializers/session_store.rb**:

```

Rails.application.config.session_store :cache_store, key: ‘_rails-evernote_session’

```

### Routes

We’ll whip up some “stand-alone” routes as well as using **resources** for routes in this project.  Open **config/routes.rb** and add the following:

```

  root 'notes#index'

  resources :notes

  get '/evernote_auth', to: 'application#evernote_auth'

  get '/evernote_auth_callback', to: 'application#evernote_auth_callback'

  get '/sync', to: 'notes#sync_notes', as: :sync

```

We’ll setup a **Note** model in ActiveRecord and we’ll use it’s *index* method for our base route.  The next routes are for authenticating and authorizing our app with Evernote.  Finally, there’s a route to sync notes to our local database.

### Note Model

The model for our **Note** object is pretty simple.  First, create a migration:

```

bin/rails g migration create_notes

```

Second, add the following to **change** method to create the **notes** table in **db/migrate/$timestamp_create_notes.rb**:

```

    create_table :notes do |t|

      t.string :title, index: true

      t.text :content

      t.string :url

    end

```

Third, execute the migration:

```

bin/rake db:migrate

```

Finally, create the **app/models/note.rb** file with:

```

class Note < ActiveRecord::Base

end

```

As you can see not a whole lot going on with the model, but enough to store the Note title, content, and URL (if there is one).

### Controllers

#### Application Controller

To authenticate with Evernote via OAuth add the following method to the **app/controllers/application_controller.rb** file:

```

class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def evernote_auth

    callback_url = 'http://localhost:3000/evernote_auth'

    if params[:oauth_verifier]

      access_token = session[:request_token].get_access_token(oauth_verifier: params[:oauth_verifier])

      session[:access_token] = access_token.token

      redirect_to root_path

    else

      client = EvernoteOAuth::Client.new

      session[:request_token] = client.request_token(:oauth_callback => callback_url)

      redirect_to session[:request_token].authorize_url

    end

  end

  def evernote_auth_callback

    session[:access_token] = access_token.token

    redirect_to '/'

  end

end

```

The first method does a couple of things. If there is a parameter named **oauth_verifier** in the request it will use the **evernote_oath** library to create an **access token** then store the token in a session variable.

If there is no **oauth_verifier** parameter that means that the Evernote App hasn’t been authorized.  The method then creates a **request token** and redirects the browser to the **authorize_url** for the app.  

Go ahead and browse to ```http://localhost:3000/evernote_auth``` and you should be redirected to the Evernote Sandbox site and asked to authorize the app.  If you haven’t started the Rails server you can do that with: ```bin/rails s```.

#### Notes Controller

Time to setup the *Notes* controller.  Create a new file **app/controllers/notes_controller.rb** and for now put:

```

class NotesController < ApplicationController

  def index

    @notes = Note.all

  end

  def show

    @note = Note.find(params[:id])

  end

  def sync_notes

    client = EvernoteOAuth::Client.new(token: session[:access_token])

    note_store = client.note_store

    notebooks = note_store.listNotebooks(session[:access_token])

    ideas_guid = ''

    notebooks.each do |notebook|

      if notebook.name == 'Ideas'

        ideas_guid = notebook.guid

      end

    end

    filter = Evernote::EDAM::NoteStore::NoteFilter.new

    filter.notebookGuid = ideas_guid

    note_list = note_store.findNotes(session[:access_token], filter, 0, 10000)

    note_list.notes.each do |note|

      doc = Nokogiri::XML(note_store.getNoteContent(note.guid))

      node = doc.xpath("//en-note")

      local_note = Note.find_by_title(note.title)

      unless local_note

        Note.create(

          title: note.title,

          content: node,

          url: note.attributes.sourceURL

        )

      end

    end

    redirect_to root_path

  end

end

```

So the **index** and **show** methods are pretty standard index gets a list of Note objects from the database and show gets a specific note based on the *id* request parameter.

The **sync_notes** method is where the magic happens.  Using the **session[:access_token]** from the **evernote_auth** methods in the ApplicationController we get a list of Notebooks from Evernote.   In my case I’m looking for a the notebook named **Ideas**.  The **guid** of the note book is saved into the **ideas_guid** variable.  Adjust the notebook name to whichever Notebook you’d like to get notes from… or don’t filter by Notebook and you can download all notes (I think anyway).

The **filter** is setup to get notes based on the Notebook **guid** then the **note_store** is used to put the notes into the **note_list** array. Well I think it’s an Evernote object, but either way it’s iterable and acts like an array for our purposes.

The **note_list** is then looped and since the Evernote API gives back XML we use the super duper **Nokogiri** library to parse the XML for the elements we want.  After checking for a **local_note** with the same title a new **Note** is created in the database if there isn’t already one.

### Templates

Create a list of all notes on the **index** path/method we’ll need to create a folder **app/views/notes** and inside there create a file named **app/views/notes/index.html.erb** with:

```

<div class="row">

  <div class="columns small-12">

    <h1>Ideas</h1>

    <%= link_to sync_path, class: 'button small' do %>

      <i class="fi-refresh"></i> &nbsp; Refresh

    <% end %>

    <hr/><br/>

    <div class="row">

      <ul class="small-block-grid-3">

        <% @notes.each do |note| %>

          <li>

            <div class="card">

              <div class="image">

              </div>

              <div class="content">

                <span class="title"><%= note.title %></span>

                <br/>

                <%= sanitize(note.content) %>

              </div>

              <div class="action">

                <div class="row">

                  <div class="columns small-6">

                    <%= link_to note_path(note), class: 'button small' do %>

                      <i class="fi-page"></i>

                    <% end %>

                  </div>

                  <div class="columns small-6">

                    <%= link_to note.url, class: 'button small' do %>

                      <i class="fi-link"></i>

                    <% end %>

                  </div>

                </div>

              </div>

            </div>

          </li>

        <% end %>

      </ul>

    </div>

  </div>

</div>

```

The layout is pretty simple.  We’re using a “card” style that will display the note title, content, and at the bottom show some links to the local note **show** page and to the Evernote link for the note (if there is one).

To create the “card” elements I used a [Foundation Building Blocks](http://zurb.com/building-blocks/material-card) Material Card example.  To add the CSS I grabbed the SCSS code and added it to **app/assets/stylesheets/application.css.scss** (after renaming the file to add the **.scss** to the end):

```

@import 'foundation-icons';

@import url(//fonts.googleapis.com/css?family=Roboto:400,500,300,100,700,900);

 html,body { // for demo only

   background: #FAFAFA;

 }

 .card {

   font-family: 'Roboto', sans-serif;

   overflow: hidden;

   box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.16), 0 2px 10px 0 rgba(0, 0, 0, 0.12);

   color: #272727;

   border-radius: 2px;

   .title {

     line-height: 3rem;

     font-size: 1.5rem;

     font-weight: 300;

   }

   .content {

     padding: 1.3rem;

     font-weight: 300;

     border-radius: 0 0 2px 2px;

   }

   p {

   margin: 0;

   }

   .action {

     border-top: 1px solid rgba(160, 160, 160, 0.2);

     padding: 1.3rem;

   }

   a {

     margin-right: 1.3rem;

     transition: color 0.3s ease;

     text-transform: uppercase;

     text-decoration: none;

   }

   .image {

     position: relative;

     .title {

       position: absolute;

       bottom: 0;

       left: 0;

       padding: 1.3rem;

       color: #fff;

     }

     img {

       border-radius: 2px 2px 0 0;

     }

   }

 }

```

Also, notice the ```@import 'foundation-icons’;``` at the top. This let’s us use the Foundation Icons gem we installed earlier.  

Finally, add the following to **app/views/notes/show.html.erb** to have a template for viewing individual cards:

```

<div class="row">

  <div class="columns small-12">

    <h1><%= @note.title %></h1>

    <%= link_to root_path, class: 'button small' do %>

      <i class="fi-left-arrow"></i> &nbsp; Back

    <% end %>

    <hr/><br/>

    <div class="card">

      <div class="image">

      </div>

      <div class="content">

        <span class="title"><%= @note.title %></span>

        <br/>

        <%= sanitize(@note.content) %>

      </div>

      <div class="action">

        <div class="row">

          <div class="columns small-6">

            <%= link_to @note.url, class: 'button small' do %>

              <i class="fi-link"></i>

            <% end %>

          </div>

        </div>

      </div>

    </div>

  </div>

</div>

```

# Conclusion

Whoops forgot one last modification.  Because my notes can get rather long, and they all consist of an **ol** element, I created the **app/assets/javascripts/notes.coffee** file with: 

```

ready_notes = ->

  #

  # Only list first 5 <li>s.

  #

  if window.location.pathname == '/'

    $.each $('ol'), (idx, note) ->

      $note = $(note)

      trunc_notes = $note.children().slice(0,5)

      $note.html(trunc_notes)

# Fire the ready function on load and refresh.

$(document).ready(ready_notes)

$(document).on('page:load', ready_notes)

```

This will remove all but the first five **li** elements of the **ol** on the **index** page.  This really tidied things up for me, but depending on your note content you can probably skip this part.  Also, there are probably a lot better ways to truncate the text, but this is the way I used cause CoffeeScript rules.

Party On!