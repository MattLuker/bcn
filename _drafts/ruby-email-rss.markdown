# Email Summary from RSS Feed

When Google ended it’s popular [Reader](http://www.google.com/reader/about/) service people were quick to pronounce the death of RSS.  I think this is very premature for several reasons, one of the main ones being that technology never dies.  Especially technology that lives on the Internets.

I need to take a moment and admit that my old Google Reader “list/feed/what have you” was totally clogged with a mass of interesting articles that I would never get around to reading even if I read them exclusively all day long for 400 years.  Ok, well maybe not that long, but the point is like my inbox my feed reader was totally banjaxed.

As [Tim Ferriss](http://fourhourworkweek.com/category/low-information-diet-and-selective-ignorance/) advises a “low information diet” is a good thing in this time of information overload and instant access.  I still want to keep up with certain blogs, news, etc so this week we’ll whip up a Ruby script to parse some RSS and email a list of goodness.

## Find The Feed

Since [DHH](https://signalvnoise.com/writers/dhh) is widely regarded as someone worth following we’ll grab the RSS for the [Signal vs Noise](https://signalvnoise.com/) blog and parse it for DHH articles.

* Browse to the link above.
* Scroll all the way to the bottom of the page.
* Click the “RSS” link.
* Copy and paste the URL from the address bar of your browser.

Or just click [here](https://signalvnoise.com/posts.rss) and copy the URL.

## Feeding the Script

I’m going to create a script named **rss_emailer.rb** and add the following code:

```
```