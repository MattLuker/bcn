---
title:  "Models Need Dating and UpDating"
date:   2015-04-30 22:42:00
categories: rails
image: models_diagram.png
---

# Wiring Things Up

Seems like a never ending task. Or maybe it’s just that going through the Treehouse Rails User Authentication course took me so long.  I feel like progress on BCN is crawling along, but that also may be because I had to work on some other projects the last week and haven’t been able to dedicate as much time as I’d like to BCN.

After another week, and weekend, I’ve gotten the User objects finished and authenticating (with signup) through email. 
<!--more-->

* Modifying the user is locked down to the current user.
* Adding Communities is locked down to being logged in.
* Modifying Communities is locked down the the User who created it.
* Editing Posts is locked down to the User who created it.


# Posts with Multiple Locations

The next big task was to change the *has_one* relationship of Posts to Locations to a *has_many* because a Post/Event could very well have multiple locations.  Since a Location already belongs_to a Post the only changes was in the Post model.

Then write some tests.

Changing the API was a lot quicker then changing the web front-end.  Or maybe I should start thinking of it as the **HTML5** front-end.  With the API, if you supply a latitude and longitude it’ll give you back the name of the location and a list of Posts with the same location name.

For the HTML side of things, I adjusted the map on the home page to have a link for  “What’s Happening Here” in the marker popup.  So when you click anywhere on the map you can either create a new Post with that Location, or view a list of posts/events at that Location.

This also involved setting up a custom route to the Location show method.  Couldn’t use the default resource route because it kept wanting to include the *:id* parameter, and since there was not Location with that ID it sent the 404 because I configured the application_controller to respond with a 404 to rescue an ActiveRecord::NotFound exception.


# Posts with Events

I think this is the last big change for the Post model.  I’m fully planning on getting things wrong, or not quite right, the first time around with this update.  

I did a little googling to see if I could find a gem, library, etc that can just blast a calendar event into your Rails app.  I did find a few things that could probably work, but it seemed like they are no longer actively maintained. 

When in comes down to it, I think all you really need to have an “Event” is to have a start date and an end date.  I guess you can get all fancy and have recurring events, notifications, etc.  Thinking to start here and see where that gets me.

Getting a test for the API with the new fields was simple enough.  Going to try and have some easy to use date and time pickers for the HTML.  Should be pretty boss.

Party On!
