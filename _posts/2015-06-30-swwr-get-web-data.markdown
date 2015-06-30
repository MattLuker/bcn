---
title: "Get Data From A Website with Ruby"
layout: post
date:   2015-06-30 14:30:00
categories: learning ruby
image: cloud_cover.jpg
---

## Finding the Data

### Open Chrome Dev Tools

Browse to the Yahoo Sports site for stats on the [Chicago Bears](http://sports.yahoo.com/nfl/teams/chi/stats/) and you will see some nice tables of statistics for major players on the team.   What we want to find out is the how the HTML elements that make up those tables are setup.

Using the Chrome Dev Tools this task is fairly straight forward.  Here's the quick and dirty of viewing the source of an HTML page:

<!--more-->

* Browse to the page you want to view number one.
* B) Open up the Chrome Developer Tools by clicking the "hamburger menu" icon in the upper right hand corner.
* Click/Hover over the "More Tools" menu item.
* Click the "Developer Tools" item in the expansion menu.

That's the long way to open Chrome Dev Tools.  If you're into the whole brevity thing simply use your keyboard and press ```Option + Command + i``` on a Mac, or ```Ctrl + Shift + i``` on a PC.

### View the Table Source

Now an easy way to find what you're looking for in the HTML goodness that is the Chrome Dev Tools **Elements** tab is to click the magnifying glass icon in the upper left hand corner of the Dev Tools pane.  After clicking the icon it turns a nice corn flower blue color and you should see sections of the page highlighted when moving your mouse around in the normal browser part of the window.

To view the source of the *Passing* table move the mouse to the word passing and give it a little clicky click.

You should see the **h5** element highlighted in the Dev Tools Elements tab.  Scroll further down and you can see the rest of the HTML for that table. Click the little triangle icon to browse down into nested elements.


![](../img/ys_tables.png)

Check out the above example if you get jammed up. 

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
require 'csv'

url = 'http://sports.yahoo.com/nfl/teams/chi/stats/'
doc = Nokogiri::HTML(open(url))
```

I like to put the URL of the site we're grabbing in a its own variable so that it's easier to change for additional sites, or to test things with other pages.  As you can probably guess by the URL in the example we're going to grab some player stats for the Chicago Bears from Yahoo Sports.

## Parsing the Data Using CSS

We've downloaded the data, so let's use Nokogiri's **css** method to find what we need.  First off let's start looping through the tables by using the **'yom-sports-stats-table'** class which you can see in the table element:

```
doc.css('.yom-sports-stats-table').each do |node|
  # ...
end
```

Next, get the name of each table since there are several of them.  By looking at the source we can see that there is a **th** cell at the beginning of the **thead** element though hidden in the display has the text name of the table:

```
  # Get the table name.
  table_name = node.search('th')[0].search('span').text
```

Now create an array from the **thead** **th** elements:

```
  # Get the table header.
  header_row = []
  node.search('th').each do |header_node|
    header_row.push(header_node['title'].to_s.strip) unless header_node['title'].to_s.strip == ''
  end
```

This **header_row** array will serve as a header in the CSV file we'll output the data to.

To line things up in the CSV file correctly add the string **'Player'** to the beginning of the header_row:

```
  header_row.unshift('Player')
```

Time to really get things going.  Open a CSV file for each table and write the **header_row**:

```
  # Open the CSV file and write the header row then parse the data rows and write them..
  CSV.open("output_files/#{table_name}.csv", "wb") do |csv|
    csv << header_row
```

Finally, setup an array for the player data and loop populate it by looping through each **td** element in the table's rows (the **tr** element):

```
    # Get the table data.
    node.search('tbody').search('tr').each do |row_node|
      data = []

      # Blast the player name onto the array.
      player_name = row_node.search('th').text
      data.push(player_name)

     # Get the rest of the data.
      row_node.search('td').each do |cell|
        data.push(cell.text)
      end

      # Write it to the file.
      csv << data
    end
  end
```

Now in the **output_files** directory you should have a slew of CSV files containing the data from this web site.  

The handy thing about CSV files is that they can be easily imported into Excel, Google Sheets, etc and those tools usually have fun ways to make nice graphs, charts, and other interesting visuals.

## Conclusion

Knowing some HTML makes it easier to grab data from a web page, but even thought really knowing HTML you can get data if you know how to loopy loop using Ruby.

Be sure to read through the [Nokogiri Documentation](http://www.rubydoc.info/github/sparklemotion/nokogiri/toplevel) if you get stuck.

Here's the full script:

```
#
# Use Nokogiri to get data from website.
#

require 'open-uri'
require 'nokogiri'
require 'csv'

url = 'http://sports.yahoo.com/nfl/teams/chi/stats/'
#doc = Nokogiri::HTML(open(url))
doc = Nokogiri::HTML(open('data_files/bears.html'))

doc.css('.yom-sports-stats-table').each do |node|
  # Get the table name.
  table_name = node.search('th')[0].search('span').text


  # Get the table header.
  header_row = []
  node.search('th').each do |header_node|
    header_row.push(header_node['title'].to_s.strip) unless header_node['title'].to_s.strip == ''
  end
  header_row.unshift('Player')

  # Open the CSV file and write the header row then parse the data rows and write them..
  CSV.open("output_files/#{table_name}.csv", "wb") do |csv|
    csv << header_row

    puts table_name, header_row.inspect

    # Get the table data.
    node.search('tbody').search('tr').each do |row_node|
      data = []

      # Blast the player name onto the array.
      player_name = row_node.search('th').text
      data.push(player_name)

      # Get the rest of the data.
      row_node.search('td').each do |cell|
        data.push(cell.text)
      end

      # Write it to the file.
      csv << data
    end
  end

end
```

Party On!
