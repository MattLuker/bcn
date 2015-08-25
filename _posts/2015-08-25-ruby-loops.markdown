---
title: "Looping and Arrays in Ruby"
date:   2015-08-25 14:30:00
layout: post
categories: ruby learning
image: loop_cover.svg
---

## Array Fun Time

Looping is the second most common programming task in my estimation.  I say second most cause I think assigning variables might be the first most common thing you’ll do while coding.

There are quite a few different ways to loop over things in Ruby.  First, you’ll need a collection of something to loop over.  That’s where arrays, hashes, etc come in.

<!--more-->
## Intro to Arrays

Basically an **Array** is a collection of things, i.e. Objects of some type or another, that are ordered and can be accessed using an integer like so:

{% highlight ruby %}
cartoons = []
cartoons.push(‘Archer’)
puts cartoons[0]
{% endhighlight %}

This small code example does some things to gently introduce you to Arrays in Ruby:

* Define an empty array and assign it to the *cartoons* variable.

* Use the [push](http://ruby-doc.org/core-2.2.0/Array.html#method-i-push) method to add an element to the end of the array.

* Print out the first element of the array.

One thing to remember about Arrays is that they always start with an index of **0**.   There is a great [post](http://stackoverflow.com/questions/7320686/why-does-the-indexing-start-with-zero-in-c) on StackOverflow about why Arrays start with 0, and basically they do because of how the computer and memory work.  It’s a speed thing.

Along with starting at 0 arrays can be accessed from the end using negative numbers:

{% highlight ruby %}
cartoons = [‘Archer’,  ‘The Simpsons’, ‘Futurama’]
puts cartoons[-1]
{% endhighlight %}

The above code will print out the last element of the array.  Also note that you can assign values to array when you initialize it.

## It’s all Circular

Back to the main theme of this post, it’s time to get into looping.

The main looping construct in Ruby (and most other languages) is the **for each in** style loop.  As in “for apple in apples” or “for cartoon in cartoons”.  It think it’s used the most because it’s the easiest to think about and say out loud… but that could be just me.

You can do an exact “for each in something” in Ruby, but it is vastly more common and preferred to use the **each** method of an Array to loop through it.  The *each* method is sort of shorthand for the “for each in something”:

{% highlight ruby %}
cartoons = [‘Archer’,  ‘The Simpsons’, ‘Futurama’]
cartoons.each do |cartoon| 
  puts cartoon
end
{% endhighlight %}

There quite a lot going on here:

* Initialize the array.

* Execute the **each** method.

* Use the **do** keyword and assign an iteration variable of *cartoon* in this case.

* Inside a code block print each element of the array using the iteration variable.

* Close the code block with the **end** keyword.

Code blocks in Ruby are very powerful and a major concept by themselves.  For now realize that anything staring with **do** and ending with **end** is a code block and the code inside the block has it’s own variable scope and what not.

The **each** method can also be executed using curly braces like so:

{% highlight ruby %}
cartoons.each { |cartoon| puts cartoon }
{% endhighlight %}

Notice looping like this doesn’t require the **do** and **end** keywords.  This style is usually used only if the loop can fit on one line.  Things can get a little confusing if you try to pack too much code into braces… at least in Ruby the style is to use *do* and *end* for multi-line loops.

## Collect/Map and Other Useful Methods

Another great Ruby looping method is [collect](http://ruby-doc.org/core-2.2.0/Array.html#method-i-collect).  This method returns a new array of things returned by the loop block.  For example:

{% highlight ruby %}
uppercase_cartoons = cartoons.collect { |cartoon| cartoon.upcase }
{% endhighlight %}

You now have an array appropriately named *uppercase_cartoons* of upper case strings.

The [include?](http://ruby-doc.org/core-2.2.0/Array.html#method-i-include-3F) method is genius for figuring out if the array contains an element:

{% highlight ruby %}
if cartoons.include?(‘Duck Tales’)
  puts “Yay!”
end
{% endhighlight %}

As you can see the **include?** method is very useful when used in an *if* statement, or at least that’s where I find it most useful.  

There a many more useful methods, but the last one I want to go over is the [uniq](http://ruby-doc.org/core-2.2.0/Array.html#method-i-uniq) method.  As you might guess **uniq** removes duplicate elements of an array:

{% highlight ruby %}
cartoons = [‘Archer’,  ‘The Simpsons’, ‘Futurama’, ‘Archer’]
uniq_cartoons = cartoons.uniq
{% endhighlight %}

Now *uniq_cartoons* would only have three elements.

## Conclusion

As with all programming languages, or at least the ones I”ve used, arrays and loops are very powerful building blocks.  With these concepts you can build very complicated and useful scripts, apps, etc.

Party On!
