---
layout: post
title:  "Rails Vendor Assets"
date:   2015-05-03 08:56:44
categories: rails
author: <a href='https://twitter.com/asommer' target='_blannk'>Adam Sommer</a>
image: <img src="http://www.thehoick.com/images/bcn_blog/bw_cleaner.jpg" title="BCN Cleaner" alt='bcn cleaner' class="post-image"/>
---

<img src="http://www.thehoick.com/images/bcn_blog/bw_cleaner.jpg" title="BCN Cleaner" alt='bcn cleaner' class="post-image"/>

# Vendor Assets

Sometimes you need to use a JavaScript library that is so cutting edge it doesn't have a gem yet.  Or maybe there aren't enough developers interested and it'll never have it's own gem.  Either way that's where the $RAILS_ROOT/vendor directory comes into the mix.
<!--more-->

Copy files into $RAILS_ROOT/vendor/assets.  There are specific subfolders for **stylesheets** and **javascripts**.  This folder structure mirrors the $RAILS_ROOT/app/assets directory and is part of the Rails Asset Pipeline.

For stylesheets, once you’ve copied a file into $RAILS_ROOT/vendor/assets/stylesheets you need to also add a couple of lines to use the stylesheet.  First create a link in the app/views/layouts/application.html.erb file. For example:

```
<%= stylesheet_link_tag 'clockpicker', media: 'all' %>
```

Then inside the config/initializers/assets.rb file add:

Rails.application.config.assets.precompile += %w( clockpicker.css )

With these two file changes you can use the styles from additional stylesheets.  Oh ya, one more thing you’ll need to do is restart your Rails server if you have it running. The running server won’t know about the change to the assets configuration until you restart it.

***Note:*** If you have more than one vendor CSS file, you can simply add the file name inside the %w() separated from the other names by a space.

For JavaScript files copy them into $RAILS_ROOT/vendor/assets/javascripts and edit the app/assets/javascripts/application.js file.  At the top there is a commented section with some “//= require ‘filename’” statements.  Add a require statement to the bottom of that section with your new file:

```
//= require clockpicker
```

You can now use the new vendor JavaScript file in your Rails application.

Woo!


Party On!
