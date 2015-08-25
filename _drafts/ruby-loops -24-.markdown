# Looping and Arrays in Ruby

## Array Fun Time

Looping is the second most common programming task in my estimation.  I say second most cause I think assigning variables might be the first most common thing you’ll do while coding.

There are quite a few different ways to loop over things in Ruby.  First, you’ll need a collection of something to loop over.  That’s where arrays, hashes, etc come in.

Basically an **Array** is a collection of things, i.e. Objects of some type or another, that are ordered and can be accessed using an integer like so:

```

cartoons = []

cartoons.push(‘Archer’)

puts cartoons[0]

``` 

This small code example does some things to gently introduce you to Arrays in Ruby:

* Define an empty array and assign it to the *cartoons* variable.

* Use the [push](http://ruby-doc.org/core-2.2.0/Array.html#method-i-push) method to add an element to the end of the array.

* Print out the first element of the array.

One thing to remember about Arrays is that they always start with an index of **0**.   There is a great [post](http://stackoverflow.com/questions/7320686/why-does-the-indexing-start-with-zero-in-c) on StackOverflow about why Arrays start with 0, and basically they do because of how the computer and memory work.  It’s a speed thing.

Along with starting at 0 arrays can be accessed from the end using negative numbers:

```

cartoons = [‘Archer’,  ‘The Simpsons’, ‘Futurama’]

puts cartoons[-1]

```

The above code will print out the last element of the array.  Also note that you can assign values to array when you initialize it.

## It’s all Circular

Back to the main theme of this post, it’s time to get into looping.

 

The main looping construct in Ruby (and most other languages) is the **for each in** style loop.  As in “for apple in apples” or “for cartoon in cartoons”.  It think it’s used the most because it’s the easiest to think about and say out loud… but that could be just me.

You can do an exact “for each in something” in Ruby, but it is vastly more common and preferred to use the **each** method of an Array to loop through it.  The *each* method is sort of shorthand for the “for each in something”:

```

cartoons = [‘Archer’,  ‘The Simpsons’, ‘Futurama’]

cartoons.each do |cartoon| 

  puts cartoon

end

```

There quite a lot going on here:

* Initialize the array.

* Execute the **each** method.

* Use the **do** keyword and assign an iteration variable of *cartoon* in this case.

* Inside a code block print each element of the array using the iteration variable.

* Close the code block with the **end** keyword.

Code blocks in Ruby are very powerful and a major concept by themselves.  For now realize that anything staring with **do** and ending with **end** is a code block and the code inside the block has it’s own variable scope and what not.

The **each** method can also be executed using curly braces like so:

```

cartoons.each { |cartoon| puts cartoon }

```

Notice looping like this doesn’t require the **do** and **end** keywords.  This style is usually used only if the loop can fit on one line.  Things can get a little confusing if you try to pack too much code into braces… at least in Ruby the style is to use *do* and *end* for multi-line loops.

## Collect and Map