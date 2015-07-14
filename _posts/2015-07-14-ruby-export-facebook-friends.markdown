---
title: "Export Your Friends From Facebook... Well Most of Them"
layout: post
date:   2015-07-14 14:30:00
categories: ruby learning
image: friends_cover.svg
---

## Everyone Wants to Keep Track of Their Friends

Keeping your friends close and your enemies closer is a saying.  Someone said it, others have repeated it.  Using the [Koala](https://github.com/arsduo/koala) gem we're going to get a list of our Facebook friends and save it to a CSV file. 

It'll be great!

<!--more-->

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

## Get an Access Token

Before you go running the script you need to copy and paste in the OAuth access key in the **Koala::Facebook::API.new** method.  

Since this is a simple script that probably won't be executed often we'll get a key from the [Graph API Explorer](https://developers.facebook.com/tools/explorer/) utility.

* Browse to the link above.
* In the "Application" dropdown select your new app.
* Click the "Get Token" button and in the dropdown select the "Get Access Token" link.
* Make sure **user_friends** is checked, and check it if it is not.
* Click the "Get Access Token" button.
* Copy and paste the "Access Token:" string from the field.

Once you done these steps you can return to the Graph API Explorer and just select your app to get the appropriate access token.

## Fire up the Script

Time to execute something.  Create a new Ruby file, I named mine **get_friends.rb**, and add the following:

```
  #
  # Get a list of Facebook Friends
  #
  
  require 'koala'
  require 'csv'
  
  # Connect to Facebook.
  @graph = Koala::Facebook::API.new('$YOUR_ACCESS_TOKEN')
  friends = @graph.get_connections("me", "taggable_friends")
  
  # Setup an array to hold the friend data.
  output_friends = []
  
  # Get a total friends count.
  friend_count = @graph.get_connection("me", "friends",api_version:"v2.0").raw_response["summary"]["total_count"]
  
  # Get the first "page" of friends.
  friends.each do |friend|
    puts friend['name']
    puts friend['picture']['data']['url']
    output_friends.push( [ friend['name'], friend['picture']['data']['url'] ] )
  end
  
  # Loop through the rest of the pages (expend the 30 to include all of your friends if needed).
  (0..30).each do |i|
    friends = friends.next_page
  
    # Stop the loop if the number of pages is less then the loop number.
    if friends.nil?
      break
    end
  
    # Add the friend data to the output array.
    friends.each do |friend|
      puts friend['name']
      puts friend['picture']['data']['url']
      output_friends.push( [ friend['name'], friend['picture']['data']['url'] ] )
    end
  end
  
  # Open the CSV file and write the header row then parse the data rows and write them.
  header_row = ['name', 'pic_url']
  CSV.open("output_files/facebook_friends.csv", "wb") do |csv|
    # Write the header row.
    csv << header_row
  
    output_friends.each do |friend|
      # Write it to the file.
      csv << friend
    end
  end
  
  puts "\n"
  puts "\n"
  puts "----------------------------------------------"
  puts "\n"
  puts "Total friends: #{friend_count}"
  puts "Total taggable friends: #{output_friends.count}"
```

**Note:** don't forget to replace the string *$YOUR_ACCESS_TOKEN* with your actual access token string.

Run the script with:

```
ruby get_friends.rb
```

You should see a list of your friend's names with the URL to their profile picture and at the end a print out of the total number of friends as well as the friends that are "taggable".  Also, in the *output_files* directory there should be a new CSV file with the name and pic_url for each friend.

The way the current version of the [Facebook API](https://developers.facebook.com/docs/apps/faq#friends_permissions) works won't allow you to get a list of all your friends, but it will let you get a list of "taggable" friends.  

To be honest I'm not 100% sure what the difference between a friend and a taggable friend is, but I'm sure it's something to do with permissions.  Even though it's sometimes inconvenient I'm all for enhanced permissions when it comes to my social networking.

Party On!
