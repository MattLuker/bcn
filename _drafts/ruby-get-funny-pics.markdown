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

## Script it Up... For Downloading

