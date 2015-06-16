---
title:  "Software Writing with Ruby"
layout: post
date:   2015-06-16 15:30:00
categories: learning ruby
image: swr_logo.svg
---

# Variables

There are certain building blocks that programs are made out of.  Probably the first thing to learn about are variables.  Starting with variables is import because variables have to do with memory, and memory is where your programs are run.  Or something like that.

I guess the real reason to start with variables is because they're one of the most used tools in your toolbox.  Besides Ruby's built in methods variables are used to hold values to be retrieved later.

<!--more-->

Think of a variable just like those old algebra problems in high school (or middle school if you were a "gifted" child and learned more then the rest of us pleebs).  You remember this problems where you have three numbers in an equation and you have to solve for *x*.  Variables are just like the *x* only in this case you know what's in the variable (or have a pretty good idea) because you loaded the contents into it.

**Note:** There will be times where you won't know the exact contents of a variable because it gets changes in the context of your program.  For example an iteration variable inside a loop is changed each time the loop is executed.  Not to worry though it is easy to find out what the contents of a variable are, but we'll get to all that later.

## Assigning Variables

In Ruby there are several ways to assign a variable.  Since we're starting at the beginning we'll focus on the simplest methods of assignment and get to more complex assignments as we go along.

To assign (create) a variable simply name the variable use the **"="** character followed by the value you'd like the variable to have.

```
url = 'http://thehoick.com'
```

In the above example we assigned the variable named  ***url*** to the *String* value of ***'http://thehoick.com'***.  We can now use the name *url* anywhere we want to spell out the string http://thehoick.com.

Variables can contain a lot of different things, but mostly the Ruby standard [data types](http://ruby-doc.org/core-2.2.2/#class-index) (remember everything in Ruby is an object) like numbers, strings, objects, etc.

For example, use a variable to store a number:

```
balls = 3
```

We now have the number **3** in the variable **balls**.  I guess you could say that we have three balls...

I mentioned earlier that variables use memory.  To understand variables and their relationship to memory think of it this way:

```A variable is a container that points to a value in memory```

## Variables Types

The first type, and the main type we'll be dealing, with are technically known as **local** variables.  These variables will be used most often in the programs we'll be writing.  A *local* variable starts with a lowercase letter or  _ character and can only be accessed in the block where it was assigned.

**Note:** We'll get into variable scope, blocks, methods, etc down the road.  For now keep on truckin'.

There are different type of variables in Ruby.  The second type is known as a **Global Variable**. 

Global variables begin with a **$** sign character and can be accessed by any part of your program.  Because they can be accessed by any part of your program most developers will discourage their use.  

But if it's there why can't I use it?

Great question.  The main reason you want to steer clear of global variables is because they can be accessed from anywhere in your program.  

Wait didn't I say that before?

Yes, yes I did.  So imagine if you set a value to the **url** variable above.  Then further down in another part of your program you assign a different value to that variable, and in a third location you use the value of that variable assuming it has the value you first assigned it.  When your program doesn't work as expected it's because the variable was re-assigned.  Doh.

This may not be a big problem and it may be easy to track down, but if you have a large number of global variables things can get hairy pretty quick. 

The third type of variable we'll probably work with is **instance** variables.  Instance variables start with a **@** symbol and can be accessed anywhere inside a class.  They belong to an instance of an object and can be accessed using dot notation on an instance of that object.

That's kind of a mouthful and we'll get more into classes and instances in future times.

We most likely won't be using the other types of variables so we'll blast on past them, but if we need to we can discuss them when we need to...

## Seeing the Value of Variables

Because our programs will be so specific to our problem/s, and because debuggers are a whole other **"thing"**, I'm going to teach you the simplest way I know (which is probably the simplest way) to view the value of a variable.  Are you ready?

To view the value of a variable simply use the **puts** method followed by the variable name like so:

```
puts url
```

If  you've been following along you should see a string printed to your screen with the contents of the **url** variable.  That string should be 'http://thehoick.com' (unless you used a different string).

**Note:** Another way to see a variable's value is to use the **print** statement, but with print you don't get an automatic new line.  Give it a try and use whatever you prefer.  There's no right or wrong way to print (or puts) a variable.


## Using Variables

A simple example of using variables is to add two numbers.  We'll add 2 to the **balls** variable from earlier (and print the result):

```
puts balls + 2
```

You should totally see the number 5.  Woo! Congratulations you now have enough understanding of variables to write a program. 

Ok ok, some more practice would be good.

How about we add 2 to our **url** variable:

```
puts url + 2
```

Doh, we got an error because you can't add two variables of different types.  Well at least you can't add a String object and a Fixnum object. 

**Note:** To see what type of object a variable contains use the **class** method ```puts url.class``` will print "String" and ```puts 2.class``` will print Fixnum (or number).

Here's a fun exercise.  Execute:

```
puts url  * 5
```

You get "http://thehoick.com" printed 5 times.  That's because Ruby will **concatenate** (or smash together as I like to think of it) a string however many times you specify with the multiplication operator.  You may never need this little "feature" of Ruby, but it could come in handy some day.


## Conclusion

That's probably enough for about variables for now.  From my experience it's easier to understand them if you just dive in and use them.

The important thing to remember is that a variable is just a box that you can put things in.  It's not the thing you put in itself it just points to it.

Party On!
