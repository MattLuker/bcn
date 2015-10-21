# Rails Playing Audio Files

## Jamming With Rails

Since getting into podcasts and recently purchasing some Spanish courses on CD there has been a rather sharp increase in audio files on my local network.  Similar to the [DVD Pila!](http://dvdpila.thehoick.com) project I’d like to whip up a web app to help manage the growing audio file pile…

Time for Audio Pila! (Rails version).  I’m thinking to setup a similar service that will list audio files in a directory structure and allow me to play them.  It’d also be very cool to be able to create playlists for them.

## Rails Project

There is no hoops to jump through this time to get access to an API, so go ahead and create a new Rails project.  In a terminal enter:

```
rails new audiopila-rails
```

If you have a different name feel free to apply it to the command above.  Also, to get Ruby and Rails setup see [this post](http://devblog.boonecommunitynetwork.com/ruby-rails-and-passenger/).

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

## Scaffolding

Start things off with some standard Rails objects by using the scaffold generator of the Audios objects:

```
bin/rails g scaffold audios
```

This will create a default **controller**, **model**, **views**, and **routes** for us.  Might as well take advantage of all Rails has to offer.

## Routes

Get things started by editting **config/routes.rb** and add the following (feel free to keep, or remove, the default documentation comments):

```
  root ‘audios#index'
  resources :audios
```

The **index** method of the Audios controller will be the root, or index, route and using **resources** to take care of the rest.


## Controllers



