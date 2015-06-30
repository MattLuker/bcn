# Get Data From A Website

## Say Hi To Nokogiri

There are many ways to get data from a website with Ruby, but the one we are going to use is the popular [Nokogiri](http://www.nokogiri.org/) library.

Assuming you already have a Ruby environment setup on your local machine, install Nokogiri from a terminal by typing:

```
gem install nokogiri
```

**Note:** if you're using the Ruby environment that ships with your operating system you may have to use the ```sudo``` utility to install the gem.

Now that we've got the gem installed let's grab some data.

## Using HTTP and What Not

To read data form the web we're going to require **open-uri** and let Nokogiri do the heavy lifting:

```
require 'open-air'
require 'nokogiri'

url = 'http://sports.yahoo.com/nfl/teams/chi/stats/'
doc = Nokogiri::HTML(open(url))
```

I like to put the URL of the site we're grabbing in a its own variable so that it's easier to change for additional sites, or to test things with other pages.  As you can probably guess by the URL in the example we're going to grab some player stats for the Chicago Bears from Yahoo Sports.

## Parsing the Data Using CSS

We've downloaded the data, so let's use Nokogiri's **css** method to find what we need:

```
doc.css('.yom-sports-stats-table').each do |node|
  puts node
end
```

### Loop Through a Table

### Grab the Data

### Output to CSV

## Conclusion