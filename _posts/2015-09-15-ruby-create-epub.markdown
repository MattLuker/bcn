---
title:  "Create Epub With Ruby"
date:   2015-09-15 14:30:00
layout: post
categories: ruby learning
image: epub_cover.svg
---

## Kindle App, The Best Thing Since Nirvana

I remember when the first PDAs came out and everyone thought the Palm Pilot was so cool.  I went to an office supply store and  was coveting them, but being a poor college student at the time didn’t have the cash to plunk down for something that could really only sync calendar appointments and play solitaire.

Then they came out with a color screen and it could read PDFs.  I was totally going to get one at that point, but again the trouble was cash flow.  It’s not that I really did anything to remedy that situation either…

Why buy an expensive electronic gadget when you can spend that hard earned cash on beer?

Anyhow, jump forward almost 10 years and we now have whole libraries available to us on our phones.  When I finally got a [G1](https://en.wikipedia.org/wiki/HTC_Dream) about a year after it came out, I was blown away by the Kindle app and how great it was to read a book anywhere.  By that time I had a second generation Kindle so reading on a device wasn’t exactly new.

Back to the task at hand.  Last week’s Ruby post went over grabbing the comments form a blog post and exporting them into an HTML file.  Well this week, you guessed it, we’re going to take that very same HTML file and convert it to an [epub](http://idpf.org/epub) file.

<!--more-->

## The Gem

For this task we’ll need to install the [gepub](https://github.com/skoji/gepub) gem.  Fire up a terminal and enter:

```
gem install gepub
```

**Note:** you might have to use the **sudo** command to install the gem.

## The Script

The great example script needs only a few modifications to work with our **comments.html** file:

{% highlight ruby %}
#!/usr/bin/env ruby
#
# Create an epub file from blog comments HTML file.
#

require 'gepub'
require 'date'

builder = GEPUB::Builder.new {
  language 'en'
  unique_identifier 'http:/thehoick.com/blog_comments', 'BookID', 'URL'
  title 'Blog Comments'
  subtitle 'Comments from a single post.'

  creator 'Adam Sommer'

  contributors 'Tim Ferriss', 'Many Others'

  date DateTime.now.strftime('%Y-%m-%dT%H:%M:%SZ')

  resources(:workdir => './output_files') {
    cover_image 'comment_cover.png' => '../data_files/comment_cover.png'
    ordered {
      file './comments.html'
      heading 'Comments'
    }
  }
}
epubname = File.join(File.dirname(__FILE__), './output_files/comments.epub')
builder.generate_epub(epubname)
{% endhighlight %}


Let’s walk through it.  The script first sets up a new builder object with details about the **epub** file to be created.

Change the **unique_identifier** to match your own site, as well as the **creator**, **contributors**, etc.

I used the cover image from this blog post for my **epub** cover, but you it didn’t really look good.  I didn’t look up the specs on what the image size for a cover image should be, but if you want it to look better than total poop you might want to use a better image.

The rest of the file is pretty understandable.  Supply a input file and an output file.  Once you execute the script you should have a **output_files/comments.epub** file (or wherever you chose to put it).  

The file can be read with iBooks, or on Android with the great [FBReader](https://fbreader.org/) app.

## Bonus .mobi File

There are several ways export a **mobi** file from an **epub** file, but a simple way I chose was to use the [Calibre](http://calibre-ebook.com/) ebook management app.  It seems to run on just about every desktop platform out there.

To get a **mobi** file just install the app, import the **epub** we created with Ruby, and then export as **mobi**.  You will then have a **comments.mobi** file in your Calibre Library folder that you can email to your Kindle email address.  If you have one that is.

The mobi file will then be available on your Kindle, phone, etc.  

## Conclusion

With an ebook version of the HTML file I’ve enjoyed reading through years of comments.  Sometimes you really stumble upon a great gem of a comment that turns you onto something bigger.

Also, it’s interesting to see the kind of things people ask of Internet celebrities… especially ones like Tim Ferriss who have become quite successful.

Party On!
