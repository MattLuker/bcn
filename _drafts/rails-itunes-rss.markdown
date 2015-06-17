---
title: "Rails iTunes and Rss"
date: 2015-06-18 07:00
categories: bcn rails
image: itunes_rss.png
---

## Feed the RSS

I was tasked with adding the ability to host audio files on the BCN website.  So that pretty much means that [BCN Rails](https://github.com/asommer70/bcn) needs to be able to stream audio files. 

Streaming audio files has become a very simple (well moslty simple) feature since the new HTML5 audio tag became supported by the major browsers.  Just add an audio tag and set the controls property and Blam!  You've got an embedded streaming audio player on your site. 

Woo, fells good!

The more tricky thing is to setup an RSS feed so that your podcast can be imported into iTunes.

## Rails and RSS

Luckily the iTunes requirements are well documented and it's also quite easy to serve XML with Rails.  It's really as simple as setting up the format of the response in your controllers.

I figured all this out from [this great post](https://www.codingfish.com/blog/129-how-to-create-rss-feed-rails-4-3-steps).  That should get you pretty much the whole way there.

You should note the logic at the bottom of the example **feed.rss.builder** file.  The example does some checking for an image attribute and adds an img tag if found.  For your feed you may, or may not, want to do this.  

For our iTunes feed we definitely didn't want to do that.  Though we did end up adding something similar to the *item* content tag.

## iTunes RSS Tags

There are a few custom rags required for iTunes to parse your feed correctly.  At least having them makes things look nice and pretty inside iTunes.

The [documentation](https://www.apple.com/itunes/podcasts/specs.html) for the podcasts has all the details.  Take a look at the builder we setup for [Communities](https://github.com/asommer70/bcn/blob/master/app/views/communities/podcast.rss.builder) to see which tags I used.

Also, I had to do a little googling to figure out how to add the special **itunes:tag_Name** tags, but there was a good explanation on how to get it working with Rails on StackOverflow (sorry forgot the link).

## Conclusion

Over all creating an iTunes RSS feed with Rails was pretty painless and kind of fun.  Since I elected to make the BCN API it's own subdirectory of controllers this was my first experience working with the whole **builder** thing.

Might go back and do some more cause it's pretty cool once you get things working.

Party On!