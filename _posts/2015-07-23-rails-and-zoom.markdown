---
title: "Medium Style Image Zoom on Rails"
date:   2015-07-23 14:30:00
layout: post
categories: rails bcn
image: rails_zoom.png
---

## Zoom.js Make it Bigger Please

I thought that just displaying images on the [BCN](https://github.com/asommer70/bcn) site was a little dull and I came across the nifty [Zoom.js](https://github.com/fat/zoom.js/tree/master) project when it was showcased on an episode of [The Treehouse Show](http://teamtreehouse.com/library/the-treehouse-show) (wish the show wasn't going to be over).

Zoom.js gives your site the ability to click on an image and view it in a fancy light box effect.  It's a jQuery plugin and works quite nice.  Though I did make a few adjustments to integrate things with Rails and Turbolinks.

Something I didn't realize until I started using Zoom.js is that it's made by [@fat](https://twitter.com/fat) one of the original developers of the [Bootstrap](http://getbootstrap.com/) framework.  Even though I've moved on to [Foundation](http://foundation.zurb.com/docs/), I still look back fondly at Bootstrap for helping me make things look good in my web apps and web sites.

<!--more-->

## Installing Zoom.js

For BCN I installed the necessary files into the **vendor/assets** directory to use the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html).  First, clone the repository:

```
git clone https://github.com/fat/zoom.js.git
```

Then copy *dist/zoom.js* to your projects **vendor/assets/javascripts** folder.  Also, copy the *css/zoom.css* file to **vendor/assets/stylesheets**.

One other thing is to download the [transition.js](https://raw.githubusercontent.com/twbs/bootstrap/master/js/transition.js) file from Bootstrap.  I guess if you're using Bootstrap in your project you probably won't have to download it again, but if you're using another framework (or none at all) go ahead and grab it.

## Marking the Photos

To enable the zoom effect just add a simple **data-action** attribute to your *img* tags:

```
<%= image_tag @user.photo.thumb('150x150#').url, :class => 'avatar', data: { action: 'zoom' } %>

```

This example is from the BCN User's profile picture.  Which also uses the super handy [Dragonfly](https://github.com/markevans/dragonfly) file upload library.

**Note to self**. Blog about the Dragonfly image upload library.

## Tweaking the Source

After installing and tagging my img elements, I noticed that the zoom effect worked if I refreshed the page, but did not if I clicked around the site then back to a page with a zoomable image on it.  This is because the Rails app is configured to use [Turbolinks](https://github.com/rails/turbolinks) which doesn't actually refresh the whole page.  Instead Turbolinks replaces the *body* element with the content from the next page.  Or at least that's how I understand Turbolinks works.

It seemed obvious that Zoom.js is being applied only when the page is initially loaded, or the very familiar jQuery ```$(function() {})``` (or ```$(document).ready()```).  Sure enough, at the end of the **zoom.js** file is the function being executed when the document is ready.

To enable zooming on Rails with Turbolinks add the following below the  ```$(function() {})``` call:

```
  $(document).on('page:load', function() {
    new ZoomService().listen()
  })
```

Now when you browse around the Rails app the **listen()** function will fire and enable the zoom effect for all img elements with the correct *data* attribute.

## Conclusion

Giving visitors to your site the option to view a larger picture is like the cherry on a sundae.  It just tops everything off.

Or like The Dude's rug... it really ties the room together.

(Maybe I should enable Zoom.js on this blog site...)

Party On!
