---
title: "Email Alerts For Tweets"
date:   2015-07-21 14:30:00
layout: post
categories: learning ruby
image: twitter_email_cover.svg
---

## My Twitter Stream is a Firehose

There's a Twitter API endpoint named [Firehose](https://dev.twitter.com/streaming/reference/get/statuses/firehose).  It has that name for a very good reason.  Parsing data from this endpoint is like drinking from the firehose:

![](/img/firehose.gif)

Haaaa, that's classic!

I don't remember when I joined Twitter, but somewhere along the line I heard it was polite to follow someone back if they follow you.  That's all well and good, but now my stream feels like a Firehose sometimes. 

So I thought it'd be cool to whip up a Ruby script to parse my stream and email me when certain people tweet.

<!--more-->

## Setup the Twitter gem

There's a great Ruby library for the Twitter API named, you guessed it, **twitter**. Woo!

Install the gem with:

```
gem install twitter mail
```

**Note:** if you're using the system Ruby you might have to prepend the install command with the*sudo* command.

The [mail](https://github.com/mikel/mail) gem makes it easy to send SMTP emails through Gmail, so we'll go ahead and install that now.

##  Setting up the Twitter App

To get access to the great (at least in my opinion) API, you need to setup your own Twitter app.  This is very easy to do:

* Log into Twitter and browse to [dev.twitter.com](https://apps.twitter.com/).
* Click the "Create New App" button.
* Fill in the form.
* Click on the new app name link.
* Click the "Keys and Access Tokens" tab.
* Get ready to copy and paste the "Consumer Key", "Consumer Secret",  "Access Token" and "Access Token Secret" strings.

## The Script

As mentioned above copy and paste the keys and tokens into the following script.  I named mine *tweet_email_notification.rb*:

{% highlight ruby %}
#
# Send email when certain people tweet.
#

require 'twitter'
require 'mail'

people = ['kennethlove', 'jseifer', 'dhh', 'Linus__Torvalds', 'arseblog']

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "CONSUMER_KEY"
  config.consumer_secret     = "CONSUMER_SECRET"
  config.access_token        = "ACCESS_TOKEN"
  config.access_token_secret = "ACCESS_TOKEN_SECRET"
end

email_body = ""
people.each do |person|
  tweets = client.user_timeline(person)
  email_body += person + "\n"
  email_body += "-------------------\n"

  tweets.each do |tweet|
    email_body += tweet.text + "\n"
    email_body += "\t" + tweet.uri + "\n"
    email_body += "\t" + tweet.created_at.strftime('%m/%d/%Y %H:%M:%S') + "\n"
    email_body += "\n"
  end

  email_body += "\n"
end


options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'example.com',
            :user_name            => 'your_email@example.com',
            :password             => 'your_password',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }



Mail.defaults do
  delivery_method :smtp, options
end

Mail.deliver do
  to 'email_receiver@yourdomain.com'
  from 'you@example.com'
  subject 'Recent Tweets'
  body email_body
end
{% endhighlight %}

What ever you do don't forget to adjust the script to your settings.  For the Twitter API change:

* CONSUMER_KEY
* CONSUMER_SECRET
* ACCESS_TOKEN
* ACCESS_TOKEN_SECRET

To those listed in your Twitter app.  Before that you should change the list of **people** to some that you are interested in following.

Maybe the [President of the United States](https://twitter.com/BarackObama)...

Change the email settings for your Gmail account.  You can also use a Google Apps for Domains account.  Also, adjust the email recipient settings.

## Conclusion

Pair this script, or a couple of them, with a scheduling utility like **[cron](https://help.ubuntu.com/community/CronHowto)** and you can receive curated lists of tweets throughout the day.  

Or even while you sleep if you schedule it to run during the night time.

Party On!
