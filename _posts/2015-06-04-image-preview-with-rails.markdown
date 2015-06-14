---
layout: post
title:  "Rails Image Upload Preview"
date:   2015-06-04 07:00:00
categories: bcn rails
image: image_preview.png
---

# Image Preview With Rails and JavaScript (well mostly JavaScript)

For those about to upload, I salute you!

I find it awesome to be able to display an image you are about to upload in the form (or somewhere on the page). I managed (through great googling and powers of copy 'n paste) to enable a similar feature in [DVD Pila!](http://dvdpila.thehoick.com) and wanted to have something similar in [BCN Rails](https://github.com/asommer70/bcn).

Thankfully a quick search of the interwebs brought me to [this wonderful Stackoverflow](http://stackoverflow.com/questions/4459379/preview-an-image-before-it-is-uploaded) post.  Let's dive in and see how to add the feature in a Rails app.
<!--more-->

# CoffeeScript Ho!

I imagine that's what Hacksaw Jim Duggan would say if he was a web developer instead of a wrestling super star from the 80s.

Keeping things CoffeeScript oriented convert the JavaScript (well jQuery) from the Stackoverflow post into Coffeescript:


```
ready_post = ->
  # Display the image to be uploaded.
  $('.photo_upload').on 'change', (e) ->
    readURL(this);

  readURL = (input) ->
    if (input.files && input.files[0])
      reader = new FileReader()

  reader.onload = (e) ->
    $('.image_to_upload').attr('src', e.target.result).removeClass('hidden');
    $swap = $('.swap')
    if $swap
      $swap.removeClass('hidden')

  reader.readAsDataURL(input.files[0]);

$(document).ready(ready_post)
$(document).on('page:load', ready_post)
```


I placed mine in a model specific coffee file, but as long as the code runs on load it should work fine anywhere.  Also, if you're averse to the hot black liquid version of JavaScript I guess you could blast it into your *app/assets/javascripts/application.js* file.

First off, the script executes the **ready_post** function when the page is fully loaded, and when [Turbolinks](https://github.com/rails/turbolinks) loads a page which usually happens when navigating from another page in the app.  

By the way have I mentioned how much I'm liking Turbolinks with this project?  Maybe I should write a post all about it...

Back to business, the real magic happens inside the **readUrl** function.  This bad boy loads up the contents of the image file in the browser then blasts the contents into the appropriate element (*.image_to_upload* in this case).  The function also looks for an element with class **.swap** and if found removes a class named **hidden**.  As the name suggests elements with the *hidden* class have CSS attributes of ```display: none;```.

Inside the **ready_post** function we're listening for a **change** event on an element (presumably a file upload element) which then executes the magic **readUrl** function.  And Bob's your uncle.


# The HTML

Time to config some elements.

In the erb template for this file upload I used these elements:

```
<%= image_tag 'avatar.png', class: 'hidden image_to_upload' %>
<br/><br/>

<%= f.label :image, 'Add a pic?'%>
<%= f.file_field :image, class: 'photo_upload' %>
```

As detailed above there is an img tag (using Rails helpers cause they're fun) with a class of **image_to_upload**, a file upload element with class **photo_upload** that is watched for a *change* event.

So when a file is selected the JavaScript (CoffeeScript) reads the file, places the contents into the img tag, and removes the CSS class causing the image to appear.

# Conclusion

I think these little features help make a web app a little more polished because people can be sure they are uploading the pic they think they are.  Takes the guess work out of it.

I feel good when I can see the file I'm about to send anyway.  Makes me feel kinda tingly.

Party On!
