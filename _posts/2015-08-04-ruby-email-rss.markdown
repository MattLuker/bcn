---
title: "Email Summary from RSS Feed"
date:   2015-08-04 14:30:00
layout: post
categories: ruby learning
image: rss_cover.png
---

## Keeping Up Is So Hard To Do
 
When Google ended it’s popular [Reader](http://www.google.com/reader/about/) service people were quick to pronounce the death of RSS.  I think this is very premature for several reasons, one of the main ones being that technology never dies.  Especially technology that lives on the Internets.

I need to take a moment and admit that my old Google Reader “list/feed/what have you” was totally clogged with a mass of interesting articles that I would never get around to reading even if I read them exclusively all day long for 400 years.  Ok, well maybe not that long, but the point is like my inbox my feed reader was totally banjaxed.

As [Tim Ferriss](http://fourhourworkweek.com/category/low-information-diet-and-selective-ignorance/) advises a “low information diet” is a good thing in this time of information overload and instant access.  I still want to keep up with certain blogs, news, etc so this week we’ll whip up a Ruby script to parse some RSS and email a list of goodness.

<!--more-->

## Find The Feed

Since [DHH](https://signalvnoise.com/writers/dhh) is widely regarded as someone worth following we’ll grab the RSS for the [Signal vs Noise](https://signalvnoise.com/) blog and parse it for DHH articles.

* Browse to the link above.
* Scroll all the way to the bottom of the page.
* Click the “RSS” link.
* Copy and paste the URL from the address bar of your browser.

Or just click [here](https://signalvnoise.com/posts.rss) and copy the URL.

## Feeding the Script

I’m going to create a script named **rss_emailer.rb** and add the following code:

{% highlight ruby %}
#
# Parse RSS feed and email article links.
#

require 'rss'
require 'open-uri'
require 'mail'

url = 'https://signalvnoise.com/posts.rss'

email_body = ""

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|
    if item.dc_creator == 'David'
      email_body += "Title: #{item.title}\n"
      email_body += "Link: #{item.link}\n"
      email_body += "\n\n"
    end
  end
  email_body += "\n"
end


options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'montomery.edu',
            :user_name            => 'sommera@montgomery.edu',
            :password             => 'Archer67',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }



Mail.defaults do
  delivery_method :smtp, options
end

Mail.deliver do
  to 'asommer70@gmail.com'
  from 'sommera@montgomery.edu'
  subject 'DHH Articles'
  body email_body
end
{% endhighlight %}

The magic in the script happens in the **feed** instance.  It’s using the Ruby [RSS}(http://ruby-doc.org/stdlib-2.0.0/libdoc/rss/rdoc/RSS.html) module which is included in Ruby core.  How very convenient, woo!

Once open the URI and parse the feed, the script loops through each *item* which can then be used to get the attributes we want to put in the email.  The *title* attribute is pretty easy, but when it comes to finding who wrote the article there’s a little bit of a catch.

The feed uses non-standard **dc:creator** tags to indicate who wrote the article.  As [this very helpful Stackoverflow post](http://stackoverflow.com/questions/1709560/how-to-retrieve-non-standard-nodes-from-rss-feed) indicates, you can use the **dc_creator** attribute of the item to get the text of the element.

After checking for the author of *’David’* the title and **link** are added to the email body, which is then sent to wherever you want to send it.  

**Note:** be sure to change the email address for the destination and the email credentials and configuration to match the account you want to send the email from.

## Conclusion

Keeping up with content is a full time job in this era where everyone is their own media company.  Hopefully little scripts like this will help to sort the signal from the noise… haaaaaa.

I also recommend reading every post on the Signal vs Noise blog cause they’re pretty much always great.

Party On!
