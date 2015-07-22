# Medium Style Image Zoom on Rails

## Zoom.js Make it Bigger Please

I thought that just displaying images on the [BCN](https://github.com/asommer70/bcn) site was a little dull and I came across the nifty [Zoom.js](https://github.com/fat/zoom.js/tree/master) project when it was showcased on an episode of [The Treehouse Show](http://teamtreehouse.com/library/the-treehouse-show) (wish the show wasn't going to be over).

Zoom.js gives your site the ability to click on an image and view it in a fancy light box effect.  It's a jQuery plugin and works quite nice.  Though I did make a few adjustments to integrate things with Rails and Turbolinks.

Something I didn't realize until I started using Zoom.js is that it's made by [@fat](https://twitter.com/fat) one of the original developers of the [Bootstrap](http://getbootstrap.com/) framework.  Even though I've moved on to [Foundation](http://foundation.zurb.com/docs/), I still look back fondly at Bootstrap for helping me make things look good in my web apps and web sites.

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

## Conclusion

Giving visitors to your site the option to view a larger picture is like the cherry on a sundae.  It just tops everything off.

Or like The Dude's rug... it really ties the room together.

Party On!
