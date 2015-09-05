# Get Some Funny Pics

## Why Rails

I love browsing the [Funny](http://imgur.com/topic/Funny) topic on Imgur.  Imgur also has a great [REST API](https://api.imgur.com/) that we can use to get the URLs of the photos.  The API also sends some meta data which we may find useful later on.

It is totally awesome that there are so many great websites developing APIs for others to build cool stuff on their platform.  The one *”problem”* with this whole trend, and it’s really more of a problem with **OAuth**, is that they all require you to provide a **callback** URL.  This isn’t a problem if you’re building a web app, but for command line applications, or mobile apps, this usually isn’t an option (or you have to do some type of hackedy hack hack work around).

So this is where [Ruby on Rails](http://rubyonrails.org/) comes in.  Now for this little project Rails is probably total overkill, but Rails is a top notch platform and well worth learning how to develop sites, apps, etc on.

And so begins a series of posts about staring out with Rails…

## Setup The Rails Project

If you don’t have Ruby and/or Ruby on Rails installed yet see this [post](http://devblog.boonecommunitynetwork.com/ruby-rails-and-passenger/).  You’ll only need the parts about installing Ruby and installing Rails, but later on if you’d like to deploy your app in a  production environment the Passenger sections will be useful.

To setup our new project we’ll use the **rails** command.  In a terminal enter:

```

rails new rails-imgur

```

I’m calling my project **rails-imgur**, but feel free to call yours something more cool.

Once that is complete you should have a directory named *rails-imgr* (or whatever you name it) with a whole bunch of new files and directories.

## Register an Application with Imgur

Like many other web applications out there on the Internets, Imgur requires you to create an "app" to use their API.  To register an application with Imgur follow these steps:

* Sign up with Imgur, or sign in, if you don't have an account.

* Browse to the [API](http://api.imgur.com/) page.

* Click the "register an application" link under the "general information" side menu.

* Click the "register their application" link in the first paragraph of the "register" section.

* Should be taken to the [/oauth2/addclient](https://api.imgur.com/oauth2/addclient) page.

* Fill out the application Name, Authorization Type (I chose Anonymous for this app), Callback URL, etc.

* Click the "submit" button.

* Copy and paste the **"Client ID"** and **"Client secret"** strings.  Gonna need those for our script.

Boom! Another app ready for greatness...

## Updates Some Gems

For our little project we’re going to need some additional Ruby gems to interact with the Imgur API and to display the images later on.  We'll interact with Imgur with, you guessed it, there is an [imgur](https://github.com/dncrht/imgur) gem and use [Foundation Clearing](http://foundation.zurb.com/docs/components/clearing.html) to create our own image gallery.

To add gems to our project edit the **Gemfile** in the root of the project directory and add:

```

gem ‘imgurapi’

gem 'foundation-rails'

```

Next, we need to install the new gems with **bundler**.  In a terminal change directories to your project directory and enter:

```

bundle install

```

There is an additional command to add Foundation to the project:

```

rails g foundation:install

```

Things should now be setup and ready for action.

## Create the callback URL.

## Put the pics in the Public folder.

## Create a view to see them.

## Maybe use Foundation Clearing.