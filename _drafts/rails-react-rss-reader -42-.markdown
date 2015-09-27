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

## Controllers