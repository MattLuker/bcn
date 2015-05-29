---
layout: post
title:  "Autocomplete with rails4-autocomplete"
date:   2015-05-28 07:00:00
categories: bcn rails
author: <a href='https://twitter.com/asommer' target='_blannk'>Adam Sommer</a>
img: <img src="http://www.thehoick.com/images/bcn_blog/rails_autocomplete.png" title="Rails Autocomplete" alt='rails autocomplete' class="post-image"/>
---

<img src="http://www.thehoick.com/images/bcn_blog/rails_autocomplete.png" title="Rails Autocomplete" alt='rails autocomplete' class="post-image"/>

# You Autocomplete Me 

Who wants to write out entire words when filling out a HTML form?  Luckily there are great tools out there in the Internets so that we don't have too.

I'm specifically talking about the [rails4-autocomplete](https://github.com/peterwillcn/rails4-autocomplete) gem.  This gem packages up the [jQuery UI Autocomplete](https://jqueryui.com/autocomplete/) extension.  What jQuery UI Autocomplete does is add a dropdown to configured input fields that contains a list of filtered options.  Where do these options come from you ask?  Well from JSON of course.  
<!--more-->

That's where the **rails4-autocomplete** gem comes in.  It integrates into Rails in the standard fashion and after a little (or maybe a medium amount) of trial and error I was able to get things working the way I'd like.

# Installation and Configuration

Installing **rails4-autocomplete** is pretty simple.  In Rails 4 add an entry to the *Gemfile*:

```
gem 'rails4-autocomplete'

# jQuery UI dependency.
gem 'jquery-ui-rails'
```

**Note:** As the [documentation](https://github.com/peterwillcn/rails4-autocomplete#user-content-before-you-start) says have jQuery UI and the Autocomplete widget installed before rails4-autocomplete.

And don't for get to rip a bundle:

```
bundle install
```

Next, add a line to the *application.js* file to include the JavaScript file (don't forget about jQuery UI):

```
//= require jquery-ui
//= require autocomplete-rails
```

In order to enable the auto-completeness make a method call in the controller. For example,:

```
autocomplete :brand, :name
```

The **:brand** is the model used for the dropdown list and **:name** is the attribute that will be used.  

Now blast in a new route in *routes.rb*:

```
get :autocomplete_brand_name, :on => :collection
```

This will be the URL that the autocomplete JavaScript calls to populate the dropdown.

There are quite a few [options](https://github.com/peterwillcn/rails4-autocomplete#options) for autocompleting and some are very useful depending on what you are doing with your app.

# Customizations

In my situation I thought an autocomplete field would be great because I have a *has-and-belongs-to-many* relationship between a Post class and a Community class.  Initially the Post.communities was populated from a multi-select input field.  This works good for a relatively small number of options, but Communities are going to be somewhat like tags (or at least I think they will be) and selecting from a huge list doesn't seem fun.

After going down a few wrong paths, and grinding my gears for a few hours, I eventually decided to remove the multi-select field and use a straight up text field with the Autocomplete **:multiple** option.

Using a **:multiple** gives you the ability to input a comma separated list, for example, and send them to the server in an array.  Some of my confusion was due to using the handy **collection_select** method which makes it easy to build a select dropdown with a option value of an object id and another attribute for the text.

Anyhoo, point of the story is that my solution is to lookup the Community objects by their **name** attribute which the autocomplete field sends.  It's probably definitely not the "Ruby" or "Rails" way to accomplish the goal, but I'm okay with that... mostly because I'm itching to move on to something else.

You can see the first draft of this app's [controller](https://github.com/asommer70/bcn/blob/master/app/controllers/posts_controller.rb) and [_form](https://github.com/asommer70/bcn/blob/master/app/views/posts/_form.html.erb) template.

Ideas on how to improve things, pull requests, derisive laughter, etc are all welcome.  

# Conclusion

I'm hoping that this solution will be intuitive enough for the audience who uses the website and if it is maybe it'll stand the test of time for at least a year or so.

I think in a simpler situation **rails4-autocomplete** would be a great solution, and I'll probably use it in other places of BCN Rails.

Party On!
