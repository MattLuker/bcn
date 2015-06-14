---
layout: post
title:  "Rails and Facebook"
date:   2015-05-14 07:00:00
categories: rails
image: facebook_and_rails.jpg
---


What we’re going to try and do is two things:

Allow people to login to our site via Facebook.
Sync Event information from RSVPed events to our site.

To accomplish this we’ll need to create a Facebook web application, integrate it with Rails via the [Koala](https://github.com/arsduo/koala) and [OmniAuth](https://github.com/mkdynamic/omniauth-facebook) libraries, and ask for additional permissions to access the Event data.

<!--more-->
Thankfully most of these steps are covered by multiple great guides out there on the  intertubes and I won’t rehash them.  I will however provide some linky links and detail the changes I needed to make to get things working.

The Koala project wiki has a great example (though it’s for Rails 3) [here](https://github.com/arsduo/koala/wiki/Koala-on-Rails).  I only used it to get some additional background on how to setup Rails and Facebook.  The main guide I used is over at Railscasts #360 [Facebook Authentication](http://railscasts.com/episodes/360-facebook-authentication).  This is a great guide that I was easily able to follow and when I finished Facebook authentication was working like a champ.

The changes I made which I could have just adjusted my Rails app to accommodate the example, but why not change the example to match my app:

# Facebook Authentication

First off I used a facebook.yml file as detailed in the [Koala example](https://github.com/arsduo/koala/wiki/Koala-on-Rails).  Figured it would be cleaner and also fits with the other services used by the app like Nominatim.  So my config/initializers/omniauth.rb file looks like:


```
provider :facebook, FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'], {:scope => 'user_about_me,email,user_events'}
```

Notice the added scope attributes.  The **user_events** option is needed to see a, you guessed it, User’s Events.

Inside my app/models/user.rb file I added a self.facebook method:

```
def self.facebook(auth)
  access_token = auth['token']
  facebook = Koala::Facebook::API.new(access_token)
end
```

For my Routes in config/routes.rb I added some custom routes:

```
  get 'auth/facebook', as: 'auth_provider'
  get 'auth/facebook/callback', to: 'user_sessions#facebook_login'
```

My app/controllers/user_sessions_controller.rb is quite a bit different from the example. You can see it [here](https://github.com/asommer70/bcn/blob/master/app/controllers/user_sessions_controller.rb), and pay close attention to the **facebook_login** method.  You’ll probably notice right away that it does not conform to the whole “Skinny Controller” paradigm and that a lot of the code should be refactored into the model.  We’ll leave that for another post.

The app/assets/javascripts/facebook.coffee.erb file is pretty much the same as the example.  I adjusted the Facebook button bind to be:

```
  $('#facebook_login').click
```

The biggest change, and most important, is how I changed the **FB.Login** call:

```
  FB.login(
    (response) ->
      window.location = '/auth/facebook/callback' if response.authResponse
    {scope: 'user_events'})
```

Once again you need to add the user_events option to the scope in order to return Events.  Thanks to [this Stackoverflow post](http://stackoverflow.com/questions/10129909/coffeescript-pass-multiple-parameters-including-an-anonymous-function) for explaining how to add an options object to a function call.  This is where translating clear JavaScript to CoffeeScript sometimes doesn’t make for clearer code.  IMHO

# Conclusion

I hope that this information along with the guides above will be helpful in explaining how to integrate Facebook with your own Rails projects.

Also, stay tuned for additional posts to clean up some of my hackedy hack hack.

Party On!
