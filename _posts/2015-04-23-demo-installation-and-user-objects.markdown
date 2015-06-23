---
title:  "Demo Installation and User Objects"
date:   2015-04-23 19:41:00
categories: rails
image: bcn_index.jpg
---

# Setting Up Capistrano (or trying to)

I spent a few hours this week trying to setup [Capistrano](http://capistranorb.com/) to automate the process of deploying the [BCN Rails](https://github.com/asommer70/bcn) project to an Ubuntu 14.04 server. The idea being to setup a demo site that people can use to see what the project is all about.

Having a demo site will also help market the project to local communities that can take advantage of having their events posted to one place.  I need to keep reminding myself to focus on developing this monster, and let the other team members do most of the outreach.  They each know more people then I do anyway.
<!--more-->

I'm sure that Capistrano is a great utility for deploying to many servers at one time, but I was having a big brown bear of a time getting it to load my project from my laptop to a server on my local LAN.

# Pivoting from Capistrano to Shell

After tracking down issue after issue and still not getting a live install setup and running for demo purposes I switched to a simple shell script to update the local project files.

Here's the script I whipped up:

```
#!/bin/bash
#
# Update BCN... Woo!
#

cd /srv/bcn
git pull
RAILS_ENV=production bin/rake assets:precompile
sudo service apache2 stop
bin/rake db:prepare RAILS_ENV=production
sudo service apache2 start
```

So it goes to the source directory pulls from the git repository then precompiles the assets.  It then stops Apache, because I wanted to wipe the database each day, and runs a [rake task](https://github.com/asommer70/bcn/blob/master/lib/tasks/sample_data.rake) to populate the database with some test entries for each type of object.  Finally starting Apache again. The Apache restart is to refresh the Passenger configuration.

Creating a custom rake task took a little time, and I've been thinking that maybe if I knew rake better Capistrano would have been easier to get setup.

I think this should work for now and work for what we want it to do.

# Creating User Objects

<img src="http://www.thehoick.com/images/bcn_blog/typing.jpg" title="User Typing" alt='user typing' class="post-image"/>

Creating User models in Rails isn’t all that hard starting out.  The more tricky parts come when you have to decide which pages of the app need to be password protected. After that you have to develop code for the user to change their user attributes, but not let an unauthenticated user change those attributes.  Oh and you have to make sure the user can only change their profile.

After all that is coded up (with tests and all that) you need to setup a way for the user to change their password.  I worked through [User Authentication With Rails](http://teamtreehouse.com/library/user-authentication-with-rails) course for the second time.  The first time I went through it because I was working on a Rails project to share photos, but then I came upon the [Lychee](http://lychee.electerious.com/) project and ended up using that instead.

After going back through the course I now have user authentication and password reset working.  Also, I've been going through the [Build a Rails API](http://teamtreehouse.com/library/build-a-rails-api) course and have REST calls for all the objects and now can be authenticated.

Still have to add some code to require authentication for some of the API methods, but should get that committed today... hopefully.

# Next Up

After some great email discussions with the group the next feature they'd like to see is a list of events from a communties' Facebook group/page/profile integrated with BCN.  My thought is to have separate scripts run via cron, or some other job scheduluing daemon, and pull in objects after parsing RSS, ICS files, etc.

Might get something integrated with the demo this weekend.

Party On!

