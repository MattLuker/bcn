---
title:  "Getting Comments From a Blog"
date:   2015-09-04 14:30:00
layout: post
categories: rails bcn
image: comment_cover.png
---

## The 4-hour Comment

Some blogs are better than other: **fact**.  Some comments are better than others: **fact**.  

These two items may be facts, or they my be the opinion of a someone who doesn’t matter to 99.9999% of the world’s population.  Either way some times I’d like to read the comments separate from the blog post itself.  Cause on some blogs the comments are almost as powerful as the blog post itself.

The specific blog I’d like to grab the comments for is the great [Tim Ferriss’ blog](http://fourhourworkweek.com/2007/11/07/how-to-learn-but-not-master-any-language-in-1-hour-plus-a-favor/) specifically some posts he’s done about language learning.  This seems like a good idea to me because I’ve recently become serious about learning Spanish.

The WordPress platform allows themes to bake in the ability to paginate [comments](https://codex.wordpress.org/Template_Tags/paginate_comments_links), and I think that is what the target blog is doing.  So we’ll use [Nokogiri](http://www.nokogiri.org/) to grab the HTML and parse out he parts we want.

<!--more-->

## Grabbing the Good Bits

Helpfully there is a link under the title that takes you down to the post's comments and it gives the total number of comments.  This is helpful because we now have a maximum value for our main loop.

To test things out this script will parse the comments-link and make sure we can grab some content:

{% highlight ruby %}
#!/usr/bin/env ruby 
# 
# Grab comments from fourhourblog.com. 
# 
require 'open-uri'
require 'nokogiri'  
url = 'http://fourhourworkweek.com/2007/11/07/how-to-learn-but-not-master-any-language-in-1-hour-plus-a-favor' 
doc = Nokogiri::HTML(open(url))

comments = '' 
total_comments = 0 
comment_count = 0  
doc.css('.comments-link').each do |node|   
  # Get total number of comments.   
  total_comments = node.children[0].text.split(' ')[0]   
  puts total_comments 
end
{% endhighlight %}

As you can see pretty simple just getting the total comments from the child of the *span* element with a class of **.comments-link**. The **text** attribute of the anchor tag is split on a space and the first element is saved into the **total_comments** variable.

There are also a few additional variables defined that we’ll update inside our node loops.

## Getting Comments Page 1

Now let’s grab the comments on page one.  The comments are inside an ordered list element so we’ll go ahead and loop through that element:

{% highlight ruby %}
#!/usr/bin/env ruby
# 
# Grab comments from fourhourblog.com. 
#
  
require 'open-uri' 
require 'nokogiri'  

url = 'http://fourhourworkweek.com/2007/11/07/how-to-learn-but-not-master-any-language-in-1-hour-plus-a-favor' 
doc = Nokogiri::HTML(open(url))  

comments = '' 
total_comments = 0 
comment_count = 0  

doc.css('.comments-link').each do |node|   
  # Get total number of comments.   
  total_comments = node.children[0].text.split(' ')[0] 
end  

puts "total_comments: #{total_comments}"  

def get_comments(doc)   
  comment_count = 0 
  comments = ''   
  next_link = ''    

  doc.css('.comment-list').each do |node|     
    # Count the number of comments on the page.     
    comment_count += node.search('li').count      
    # Append the comment list.     
    comments += node.to_s      #
     Get the next page.     
     doc.css('#comment-nav-below').each do |node|  
       next_link = node.search('.nav-next').children[0]
     end   
   end   
   return [comments, comment_count, next_link] 
end
{% endhighlight %}

So the magic in this part is done by the **get_comments** method.  The method takes a **doc** as an argument (a Nokogiri HTML doc in this case) and loops through the *ol* element with  the **.comment-list** class.  Inside the loop we setup some variables to hold the comments, the next_link and the count.  

To get the actual comment HTML is saved using the **to_s** method and the **comment_count** is retrieved by the **search** method looking for *li* elements and using the **count** method.

The **next_link** is retrieved using another **search** method call for the element with a class of **nav-next** which will be inside an element with the **id** of **comment-nav-below**.

The needed data is then packaged up into an array and returned.  Using a hash might be better, but I was going for quick and dirty at this point.

## Looping The Comment Pages

Now that we have the data we want from the first page we can update the variables we set at the beginning the script and use a **while** loop to loop through the comment pages:

{% highlight ruby %}
first_results = get_comments(doc) 
comments += first_results[0] 
comment_count += first_results[1] 
next_link = first_results[2]  
while comment_count < total_comments.to_i   
  doc = Nokogiri::HTML(open(next_link.attr('href')))   
  results = get_comments(doc)   

  comments += results[0]   
  comment_count += results[1]   
  next_link = results[2]   

  if next_link.nil?     
    break   
  end 
end
{% endhighlight %}

So the meat of the loop is checking the running comment total against the grand total, but really the loop is exiting once the **next_link** is **nil**.  On the last page of comments there won’t be a next link… obviously time to call the **break** method.  And maybe get a KitKat…

## Output some HTML

Saving the comments is the point of the exercise so let’s create a new HTML file containing the comments:

```
open('output_files/comments.html', 'w') { |f|   f.puts comments }
```

We now have a pretty large amount of HTML that we can write out to a file.  One thing to note is that the file won’t be valid HTML unit you add some additional html, head, body, etc tags.

## Conclusion

If content is king it should be easier for every one to digest.  I think blog post with over 700 comments totally require paging, but it makes the comments a little hard to read. Especially if you’re coming to the content years later.

There’s a lot that could be done to make this post better, but maybe we’ll leave that for a future post.

Party On!
