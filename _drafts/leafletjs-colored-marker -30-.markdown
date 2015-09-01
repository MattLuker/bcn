# Colored Map Marker with Leaftlet.js and Rails

The main feature of the [BCN](https://github.com/asommer70/bcn) project is to have events listed on a map to show you what is going on close by in the near future.  I’m 80% sure we’ve accomplished that goal.

Another feature is to color code the events by Community and a logical next step is to color code the markers on the map for that event.  Turns out this isn’t too hard to accomplish with the great [Leaflet.js](http://leafletjs.com/) library.  Leaflet.js allows you to make great looking maps using the [Open Street Maps](http://www.openstreetmap.org/) APIs.

## Installing Leaflet.js

To install Leaflet.js I used the **vendor/assets** approach.  According to the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html) you just copy the files JavaScript files into *vendor/assets/javascripts* and CSS/SCSS files into *vendor/assets/stylesheets* and include them in the application files.

So download the latest version of Leaflet.js from [here](http://leafletjs.com/download.html), unzip the zippy zip file, and copy **leaftlet.js** to *vendor/assets/javascripts* and **leaflet.css** to *vendor/assets/stylesheets*.  And Bob’s Your Uncle!

Well not quite yet.  Next, add the **require** statements to the **app/assets/javascript/application.js** file:

```

//= require leaflet

```

**Note:** if you use a CoffeeScript for *application.js* just add it there.

And add a **require** to **app/assets/stylesheets/applications.css.scss** (in my case yours could be straight up CSS):

```

*= require leaflet

```

If your Rails server is running you might have to restart it at this point to get the new files into the pipeline.

## Default Icon

In a helper CoffeeScript I setup a default icon for markers:

```

# Set the marker icon to custom SVG. @divDefaultIcon = L.divIcon({   className: 'marker-div-icon',   html: get_svg('#632816', 30, 55),   popupAnchor: [-9, -53],   iconAnchor: [20, 55], });

```

The [DivIcon](http://leafletjs.com/reference.html#divicon) documentation is pretty good and that’s where I got most of the options for the icons.  The regular [Icon](http://leafletjs.com/reference.html#icon) documentation has basically the same options and goes into a little more detail on what they do, so you might read through that as well.

Basically we’re setting the icon to a **div** element instead of an image element.  The **popupAnchor** and **iconAnchor** options set where the marker starts relative to the cursor and where the popup appears relative to the marker and the **html** option sets the contents of the div.

I’m sure it’s better to do the maths to figure out based on the size of the contents of your div where to place the anchor points, but that’s not the approach I took.  Basically I played around with the numbers until I had things looking good.  The process looks like change number, refresh page, change number, refresh page, rinse, repeat.

So the question on your mind might be “What’s the **get_svg** function?”.  And that would be a great question.

## Getting SVGs

The **get_svg** in the default Leaflet icon is a custom function I whipped up to set the color and size of an SVG file that is the contents of the icon’s *div* element.  In case that wasn’t obvious.

The magic of the **get_svg** function happens in the [pins.coffee](https://github.com/asommer70/bcn/blob/master/app/assets/javascripts/pins.coffee) file.  The file basically consists of a CoffeeScript function that has a multi-line string that contains the particular SVG we’re using for the marker.  In the string are interpolated variables for width, height, and color.  Then the SVG string is returned by the function.

And now Bob is truly your Uncle!

## Setting Community Icons

Now based on the color assigned to each Community we can adjust the icon to make the event markers easily identifiable. 

```

divCommunityIcon = L.divIcon({   className: 'marker-div-icon',   html: get_svg(community.color, 50, 50),   popupAnchor: [8, -3], });

```

This magic is done in the [map_helpers.coffee](https://github.com/asommer70/bcn/blob/master/app/assets/javascripts/map_helpers.coffee) file.

## Conclusion

Leaflet.js is an awesome library (fact) and there are a lot of options for making custom maps, icons, layers, etc.  If your project is using a map of some type I highly recommend it.

Using SVGs in this way makes me want to dive into more advanced things with them.  Love me some SVGs.

Party On!