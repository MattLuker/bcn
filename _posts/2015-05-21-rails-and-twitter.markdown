---
layout: post
title:  "Rails and Twitter"
date:   2015-05-21 07:00:00
categories: bcn rails
image: twitter_and_rails.png
---

# Rails Twitter Authentication

Make easy work of integrating Twitter authentication into your Ruby on Rails app with the [omniuath-twitter](https://github.com/arunagw/omniauth-twitter) gem.  Very similar to the *omniauth-facebook* gem, this one allows you to easily authenticate users with Twitter’s OAuth API.
<!--more-->

# Guides and Setup

Besides pretty good documentation in the [README](https://github.com/arunagw/omniauth-twitter/blob/master/README.md), I used [this guide](https://gorails.com/episodes/omniauth-twitter-sign-in) at Go Railsto help me integrate the package into BCN Rails.  The guide does a good job of walking you through setting the controller method to call a model method which authenticates to Twitter.

The guide uses the **first_or_create** method which seems awesome to me, but for whatever reason (maybe cause I’m not using Omniauth to manage email signups), it didn’t work for me.  I adjusted the model method to do a more standard lookup:

```
user = User.find_by(username: auth_hash.info.nickname)
```

Then if the user isn't found go ahead and create it.

I setup a config file *twitter.yml* and placed the Twitter app key and secret into it.  Then added a line to a renamed *config/initializers/social_auth.rb* (was named facebook.rb):

```
TWITTER_CONFIG = Rails.application.config_for(:twitter)
```

and in *config/initializers/omniauth.rb* I added another provider for Twitter:

```
provider :twitter, TWITTER_CONFIG['app_id'], TWITTER_CONFIG['secret']
```

Similar to Facebook my model has a self.twitter method to create, or find, the authenticating user.  In the *user_sessions_controller* I added a **twitter_login** method with this magic line that sends the Omniauth header to the model:

```
user = User.twitter(request.env['omniauth.auth'])
```

Conclusion

I’m so glad that the OAuth protocol exists and so many big sites are using it.  It sure makes it easy to allow users to not have to remember another new username and password.

One thing I ran into while developing this part of the app was the Twitter API rate limit. According to the [documentation](https://dev.twitter.com/rest/public/rate-limiting) you only get 15 authentication calls in 15 minutes.  So that left me waiting a few minutes after hitting that and seeing that I wasn’t getting all the info I needed in my callback.

Better then waiting an hour I guess.

Party On!

