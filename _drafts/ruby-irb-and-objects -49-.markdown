# irb and Ruby Objects

## Hello World

Before we dive into developing our own scripts, and apps, let’s take a look at the **I**nteractive **R**u**b**y shell or **irb**.  The irb utility is a REPL (Read Evaluate Print Loop) for Ruby.  What this means is that you can enter Ruby methods, load files, etc and experiment with how they work without having to execute a file.

This is very handy when learning new methods, double checking regular expressions, and a whole slew of other use cases.  Most languages seem to have a REPL and **irb** is great.

To enter **irb** open a terminal and type:

```

irb

```

Once you’re in the Ruby shell you can use common methods like **puts** to print some text to the screen:

```

puts “Hello World”

```

Woo, feels good to accomplish the first thing every programming book covers.  “Hello World”!!!

## Loops

Using **irb** you can also loop over an array like so:

```

arr = [1, 2, 3]

arr.each do { |i| puts I }

```

This very simple example creates an [Array](http://ruby-doc.org/core-2.2.0/Array.html) with three entries of simple numbers.  The **each** method is then called and each element of the array is printed using the **puts** method.

Fun Fun!

## Ruby Objects

Ruby being a pure [object oriented](https://en.wikipedia.org/wiki/Object-oriented_programming) language makes every thing into an object.  Yes, even numbers are objects.  To test this in **irb** enter:

```

1.class

```

As you can see the number **1** has a class of ```Fixnum < Integer```.  Pretty cool.

Objects in Ruby come with a bunch of methods predefined and you can see them all with the **methods** method:

```

1.methods

```

Bazinga!  

Some more useful methods are the **to_s** and **to_i** methods. They convert an object into a String and an Integer respectively.  

```

1.to_s.class

```

Notice that you can also **”chain”** methods together.  This is great if you have many things you’d like to accomplish in a small amount of space.  Also, it’s cool.

Lastly, the **inspect** method is great for seeing the attributes of an object.  For example:

```

a = {one: 2, three: 4}

a.inspect

```

Here the **inspect** method lists the keys and values of the Hash, but in more complex objects you can view the values of many different values.

## Conclusion

We’ve jumped into Ruby and briefly showed how some common things work, but there is a lot more to Ruby.  Don’t worry if you get overwhelmed the longer you use Ruby the more you’ll pick up.

Party On!