# Methods of Ruby

## Learning About Ruby Methods

For technically minded peeps **methods** are **functions** defined as part of a **class**.  Since everything in Ruby is an object (defined in a class) event “stand-alone” functions are actually methods.

Methods allow you to write a re-usable chunk of code that does a specific thing.  Like say parse a text file, update a database, etc.

## Defining Methods

Methods start with the **def** keyword followed by the method name, any arguments, and end with the **end** keyword.  In between the *def* and *end* you can place any Ruby code you’d like.

As an example we’ll define a small function to say “hello” how ever many times we’d like.  In a file enter:

{% highlight ruby %}
#!/usr/bin/env ruby
#
# Testing Methods… Woo.
#

def say_hello(times)
  puts “Hello…” * times
end
{% endhighlight %}

Execute the file and see what happens. 

Absolutely Nothing!  Never get involved in a land war in Asia…

Oh, right back to Ruby.  Nothing happened because though we defined a new method and the method uses **puts** to print a string we never actually called the new method.  Call the method like so:

{% highlight ruby %}
#!/usr/bin/env ruby
#
# Testing Methods… Woo.
#

def say_hello(times)
  puts “Hello…” * times
end

say_hello(8)
{% endhighlight %}

Now when you run the method you should see **8** hellos printed to the screen.

Very Cool, Right?

## Arguments

Methods in Ruby can have any number of **arguments** (the variable we defined in the method declaration).  Arguments can also be any Ruby type such as strings, hashes, arrays, etc.

Hashes are quite useful because you can pass in “labeled” arguments like so:

{% highlight ruby %}
#!/usr/bin/env ruby
#
# Testing Methods… Woo.
#

def say_hello(hello_hash)
  puts “#{hello_hash[’:greeting’]…” * hello_hash[:multiplier]
end

say_hello( { greeting: ‘Hello Beans’, multiplier: 4 } )
{% endhighlight %}

This version will interpolate the **hello_hash[:greeting]** value and print it to the screens as many times as the **hello_hash[:multiplier]** value specifies.

## Return Values

By default Ruby returns the result of the last expression from a method.  So for example:

{% highlight ruby %}
#!/usr/bin/env ruby
#
# Testing Methods… Woo.
#

def say_hello(hello_hash)
  puts “#{hello_hash[’:greeting’]…” * hello_hash[:multiplier]
  false
end

result = say_hello( { greeting: ‘Hello Beans’, multiplier: 4 } )
puts result
{% endhighlight %}

The value of **result** will be **false** cause we placed a lonely **false** statement at the end of the method.  To return a specific value specify it with the **return** keyword (or maybe return is just a statement, or maybe it’s a Ruby method… tell you the truth I’m not 100% sure, but it works):

{% highlight ruby %}
#!/usr/bin/env ruby
#
# Testing Methods… Woo.
#

def say_hello(hello_hash)
  puts “#{hello_hash[’:greeting’]…” * hello_hash[:multiplier]
  return ‘Tacos’
end

result = say_hello( { greeting: ‘Hello Beans’, multiplier: 4 } )
puts result
{% endhighlight %}

Woo Tacos!

## Conclusion

Methods are very great for segmenting your code and making it easier to understand, update, and improve.  If you script, app, etc gets too long and does a lot of different things it’s a good idea to separate some of the functionality into different methods.

Your future self will thank you.

Party On!