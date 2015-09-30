# Hashes in Ruby

##  The Workhorse of the Internet

I covered looping over Arrays in a  [previous post](http://devblog.boonecommunitynetwork.com/ruby-loops/), and now it’s time to cover looping through a Ruby [Hash](http://ruby-doc.org/core-2.2.0/Hash.html).

I always thought a calling something a Hash was kind of strange.  Isn’t hash a delicious breakfast food?

Hashes in Ruby are known as *dictionaries* in Python, *associative arrays* in PHP, *plain objects* in JavaScript, and well *hashes* in Perl (but who uses Perl now anyway?).  Basically a hash is a object consisting of key/value pairs and it’s awesome.

## Looping

The simplest way to loop over a Hash in Ruby is, like looping over Arrays, to use the **each** method.  Suppose we have a hash like this:

```

hasher = {

  id: 1,

  status: ‘good’,

  content: ‘I like cheese…’

}

```

The **each** method will take two arguments in the **do** block one for the **key** and another for the **value**:

```

hasher.each do |key, value|

  puts “key: #{key}, value: #{value}”

end

```

This in very useful because usually when looping over a Hash you’re going to want to do something with either the hashes keys, the values, or probably both.

## Select Method

Similar to the **each** method the **select** method iterates through a hash and returns a new hash of entries that return true from the block.  So for example:

```

hasher = {

  id: 1,

  status: ‘good’,

  content: ‘I like cheese…’

}

complete = hasher.select do |key, value|

  value == ‘good’

end

```

The **complete** hash now has the key ‘status’ and it’s value.  Pretty cool!

## Useful Methods

Like Arrays, and well any object in Ruby, there are a lot of methods for the Hash object that help accomplish different things.  Some of the more frequently used methods are:

* **has_key?** - takes a string argument (key) and checks the hash for the it.

* **merge** - returns a new hash containing the keys and values of the original hash and the hash passed as an argument.

* **key** - gives you the key for a value… provided you know the value and want to get it’s key.

* **value** - similar to *key*, this method returns true if the value is present.

* **length** - returns the number of keys in the hash.

A couple of other useful methods are the **each_key** and **each_value** methods.  They let you iterate over just they keys or just the values.  I find I mostly just use **each** though.

## Conclusion

Like most languages, and whatever you call it, Hashes in Ruby are very useful and frequently used.  You’ll also see them used as arguments to methods as a way to accept a random number of arguments.  

Also, in web programming you’ll often see Hashes converted to straight up JSON objects.  That’s a topic for another time though.

Party On!