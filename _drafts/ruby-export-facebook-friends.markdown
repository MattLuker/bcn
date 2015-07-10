# Export Your Friends From Facebook

Keeping your friends close and your enemies closer is a saying.  Someone said it, others have repeated it.  Using the [Koala](https://github.com/arsduo/koala) gem we're going to get a list of our Facebook friends and save it to a CSV file. 

It'll be great!

## Create an App

You will need to create a Facebook App to use their API.  To do so log into Facebook and go to the [Developers](https://developers.facebook.com/) page.

* In the "My Apps" menu click the "Add a New App" link at the bottom.
* Choose "Website" in the popup overlay.
* F ill out the name of your app (choose something catchy like GetFriends).
* Click the Create New Facebook App ID button.
* Choose a "Category" for the app (I chose Utilities cause it seemed fitting).
* Click the "Create App ID" button.

Your new app is now setup.

Now click the "Skip Quick Start" button in the top right-hand corner of the site because for our little command line script we won't need to configure all the options for the app.

If you're creating something more substantial then by all means fill out the full app details.

## Install Koala

Installing the gem is easy peasy:

```
gem install koala
```

**Note:** if you are using the system Ruby install you might have to use the *sudo* utility.

Pow! You're all set on the workstation end.

## Fire up the Script

Time to execute something.  Create a new Ruby file, I named mine **get_friends.rb**, and add the following:

```
require 'koala'

@graph = Koala::Facebook::API.new($YOUR_AUTH_KEY)

friends = @graph.get_connections("me", "friends")

friends.each do |friend|
  puts friend['name']
  
  puts friend.inspect
end
```

Before you go running the script you need to copy and paste in the OAuth access key in the **Koala::Facebook::API.new** method.  Since this is a simple script that probably won't be executed often we'll get a key from the [Graph API Explorer](https://developers.facebook.com/tools/explorer/) utility.

* Browse to the Graph API Explorer page linked above.
* Copy and paste the "Access Token" string into the script.

