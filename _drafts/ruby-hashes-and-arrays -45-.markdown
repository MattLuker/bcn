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