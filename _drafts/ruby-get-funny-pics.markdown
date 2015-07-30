# Get Some Funny Pics

## Imgur Funny

Grabbing a slew of photos from the web can be done in a jiffy with Ruby and [nokogiri](http://www.nokogiri.org/).  I love browsing the [Funny](http://imgur.com/topic/Funny) topic on Imgur.

Imgur also has a great [REST API](https://api.imgur.com/) that we can use to get the URLs of the photos.  The API also sends some meta data which we may find useful later on.

We'll interact with Imgur with, you guessed it, the [imgur](https://github.com/dncrht/imgur) gem.

## Install the Gem... Now

Whip open a terminal and enter:

```
gem install imgurapi
```

**Note:** if you need to use **sudo** before the command.

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

## Script it Up... For Downloading

