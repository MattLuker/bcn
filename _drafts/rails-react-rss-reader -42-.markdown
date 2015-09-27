# Reading RSS with React and Rails

## React and Rails, huh?

The [React](https://facebook.github.io/react/) JavaScript library has blasted into popularity since Facebook released it a few years ago.  I know that for me it’s become increasingly something that I’ve wanted to develop with and it appears that the time has finally come.

Since Google shuttered their popular [Google Reader](http://www.google.com/reader/about/) RSS reader, there has been a quite a [few projects](http://gizmodo.com/10-google-reader-alternatives-that-will-ease-your-rss-p-5990540) picking up the slack.

Fortunately RSS readers are easy to code because RSS is a standard XML format for syndicating content.  Also, there are a ton of great libraries, for practically every language, to parse, consume, etc RSS feeds.

## Rails Project

There is no hoops to jump through this time to get access to an API, so go ahead and create a new Rails project.  In a terminal enter:

```

rails new rails-rss

```

Name your project as you’d like.  Also, to get Ruby and Rails setup see [this post](http://devblog.boonecommunitynetwork.com/ruby-rails-and-passenger/).

### Gems

We’ll need a couple gems, but they’re some we’ve seen before.  Add the following to the project’s **Gemfile**:

```

gem 'nokogiri'

gem 'foundation-rails'

gem 'foundation-icons-sass-rails'

gem 'react-rails', '~> 1.3.0'

```

We’ll use [Nokogiri](http://www.nokogiri.org/) to parse the XML from the RSS feed, and [Foundation](http://foundation.zurb.com/docs/) to make things look all shiny and chrome.  Heh, watched [Mad Max Fury Road](http://www.madmaxmovie.com/) recently.

Now setup Foundation, React, and install the additional gems:

```

rails g foundation:install

rails g react:install

bundle install

```

### Configure Rails React

Edit the *environment* files to add configuration options for Rails React.  In **config/environments/development.rb** add:

```

  config.react.variant = :development

```

And in **config/environments/production.rb**:

```

  config.react.variant = :production

```

The project is now ready for prime time.

## Routes

The routes are pretty simple for this app.  Edit **config/routes.rb** and add the following:

```

  root 'feeds#index'

  resources :feeds

```

As you can see we’re using the **index** method of the Feeds controller for the root, or index, route and using **resources** to take care of the routes for the Feeds model.

## Models

Create a **Feed** model, and corresponding **feeds** table, with a migration:

```

bin/rails g migration create_feeds

```

Add the following to the **change** method in the **db/migrate/$DATE_create_feeds.rb** file:

```

    create_table :feeds do |t|

      t.string :title

      t.string :query

      t.string :base_url

    end

```

Run the migration:

```

bin/rake db:migrate

```

Whip up a simple model in **app/models/feed.rb** with:

```

class Feed < ActiveRecord::Base

end

```

## Controllers

The controller is a little more complicated than previous Rails projects.  Since we’re taking advantage of Rails [resources](http://guides.rubyonrails.org/routing.html#resource-routing-the-rails-default) there are some methods for CRUD operations.

```

class FeedsController < ApplicationController

  def index

    @feeds = Feed.all

  end

  def new

    @feed = Feed.new

  end

  def create

    @feed = Feed.create(feed_params)

    redirect_to root_path

  end

  def edit

    @feed = Feed.find(params[:id])

  end

  def update

    @feed = Feed.find(params[:id])

    @feed.update(feed_params)

    redirect_to root_path

  end

  def show

    @feed = Feed.find(params[:id])

    require 'open-uri'

    require 'nokogiri'

    feed_url = "#{@feed.base_url}/search/jjj?format=rss&query=#{@feed.query}&sort=rel"

    doc = Nokogiri::XML(open(feed_url))

    @posts = []

    doc.css('item').each_with_index do |node, idx|

       node.css('title').text

       item = {

         id: idx,

         title: node.css('title').text,

         description: node.css('description').text,

         link: node.css('link').text,

         date: node.at('//dc:date').text

       }

       @posts.push(item)

    end

  end

  private

    def feed_params

      params[:feed].permit(:title, :query, :base_url)

    end

end

```

Here’s a quick explanation of the controller methods:

* **index:** lists all the feeds in the database.

* **new:** really just renders the **_form** partial and creates a *new* Feed object.

* **create:** actually does the Feed creating via HTTP POST params.

* **edit:** similar to the new method it’s main job is to render the **_form** partial and get the **@feed** object from the database via the **id** parameter (**params[:id]**).

* **update:** takes the results of the form partial and saves it to a current Feed object via HTTP PUT/PATCH.

* **show:** is where the magic happens.  This method looks up a Feed object via the **id** parameter, then creates a URL for Craigslist from the **@feed.base_url**, fetches the RSS feed with the **Nokogiri** library, parses the data looping through the RSS item tags , and creates an array of hashes from the RSS data.

* **feed_params:** is a Rails [Strong Parameters](http://edgeguides.rubyonrails.org/action_controller_overview.html#strong-parameters) method to ensure the integrity of the form data.

PFfeeww, that’s a lot to chew on.  Hopefully it all makes sense…

## Views

Now, give the controller methods something to output to.  Create a directory in **app/views** named **feeds** and create the **app/views/feeds/index.html.erb** file with:

```

<br/><br/>

<div class="row">

  <div class="columns small-12">

    <h2>Feeds</h2>

    <%= link_to 'New Feed', new_feed_path, class: "button success small" %>

    <hr/>

    <%= react_component 'Feeds', { data: @feeds } %>

    <br/>

  </div>

</div>

```

Create a **app/views/feeds/new.html.erb** with:

```

<div class="row">

  <div class="columns small-12">

    <h2>New Feed</h2>

    <%= render 'form' %>

  </div>

</div>

```

Create a **app/views/feeds/edit.html.erb** with:

```

<div class="row">

  <div class="columns small-12">

    <h2>Edit Feed | <%= @feed.title %></h2>

    <%= render 'form' %>

    <br/>

    <%= link_to 'Back', root_path %>

  </div>

</div>

```

The  **app/views/feeds/_form.html.erb** partial needs:

```

<br/><br/>

<div class="row">

  <div class="columns small-12">

    <%= form_for @feed do |f| %>

      <div class="row">

        <div class="columns large-4">

          <%= f.text_field :title, placeholder: 'Title' %>

        </div>

      </div>

      <div class="row">

        <div class="columns large-4">

          <%= f.text_field :query, placeholder: 'Query' %>

        </div>

      </div>

      <div class="row">

        <div class="columns large-4">

          <%= f.text_field :base_url, placeholder: 'Base URL' %>

        </div>

      </div>

      <div class="row">

        <div class="columns large-4">

          <%= f.submit class: 'button small' %>

        </div>

      </div>

    <% end %>

  </div>

</div>

```

And finally the main event, the **app/views/feeds/show.html.erb** has:

```

<br/><br/>

<div class="row">

  <div class="columns small-12">

    <h4><em><%= @feed.title %></em> Posts</h4>

    <hr/><br/>

    <%= react_component 'Posts', { data: @posts } %>

    <% if @posts.length == 0 %>

      <p>

        No posts for this query: <em><%= @feed.query %></em>.

      </p>

    <% end %>

    <br/><br/>

    <%= link_to 'Back', root_path %>

  </div>

</div>

```

Also, the **app/assets/stylesheets/application.css.scss** uses the *”card”* elements form previous posts:

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

**Note:** don’t forget to rename the **app/assets/stylesheets/application.css** file to have the **.scss** extension on the end.  

## React Components

If you paid close attention there are some **React** components in the **index** and **show** templates:

```

    <%= react_component 'Feeds', { data: @feeds } %>

```

And

```

    <%= react_component 'Posts', { data: @posts } %>

```

These elements are part of the **react-rails** gem and create a div element with properties that React can use.  So let’s whip up some React components to display the output of the RSS feed.

First, create a file named **app/assets/javascripts/components/feeds.js.jsx** this is a [React JSX](https://facebook.github.io/react/docs/jsx-in-depth.html) file and will be compiled to JavaScript by the Rails pipeline again via the **react-rails** gem.  The contents of the file are:

```

var Feeds = React.createClass({

  render: function() {

    var feeds = this.props.data.map(function(feeds){

      return <Feed {...feeds} />

    });

    return <ul className="small-block-grid-3" key={this.props.id}>

        {feeds}

      </ul>

  },

})

```

The next React component, which you see above in the **<Feed {…feeds}/>** tag is **app/assets/javascripts/components/feeds.js.jsx**:

```

var Feed = React.createClass({

  render: function() {

    return <li key={this.props.id}>

    <div className="card">

      <div className="image">

      </div>

      <div className="content">

        <span className="title">{this.props.title}</span>

        <br/>

        <strong>Query:</strong> {this.props.query}

        <br/>

        <strong>Base URL:</strong> {this.props.base_url}

        <br/><br/>

      </div>

      <div classNameName="action">

        <div classNameName="row">

          <div className="columns small-12">

            <a href={'/feeds/' + this.props.id} className="button tiny">

              <i className="fi-link"></i>

            </a>

            <a href={'/feeds/' + this.props.id + '/edit'} className="button tiny">

              <i className="fi-pencil"></i>

            </a>

          </div>

        </div>

      </div>

    </div>

      </li>

  }

})

```

This component takes the array of Feeds and sets up a card element for each one.

Now, for the RSS feed contents.  Remember in the **feeds_controller.rb** **show** method we created an array of hashes named **@posts**.  To display them we’ll create a file named **app/assets/javascripts/components/posts.js.jsx** with:

```

var Posts = React.createClass({

  render: function() {

    var posts = this.props.data.map(function(posts){

      return <Post {...posts} />

    });

    return <ul className="accordion" data-accordion key={this.props.id}>

        {posts}

      </ul>

  },

})

```

And then the **app/assets/javascripts/components/post.js.jsx** to display the actual RSS feed item:

```

var Post = React.createClass({

  render: function() {

    return <li key={this.props.id} className="accordion-navigation">

      <a href={'#post_' + this.props.id}>{this.props.title}</a>

      <div id={'post_' + this.props.id} className="content active">

        <p>

          {this.props.description}

        </p>

        <a href={this.props.link} target="_blank" className="button tiny"><i className="fi-link"></i></a>

        &nbsp;&nbsp;

        <span className="date">{this.props.date}</span>

      </div>

    </li>

  }

})

```

Pow Rails and React working together!

## Conclusion

This is a very basic use of React and frankly not terribly useful since we’re not taking advantage of Reacts awesome data binding features, but it was a fun starter project (and hopefully useful).

Also, there are some features that I’d like to implement and maybe cover in a future post.  Things like deleting a Feed and getting the Foundation according JavaScript code to work.  Once thats working we won’t have to add the **active** class to all the **content** divs inside the accordion li elements.

We’ll get to that later on… maybe.

Party On!