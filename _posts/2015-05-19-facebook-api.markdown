---
layout: post
title:  "Facebook API"
date:   2015-05-19 07:00:00
categories: bcn
image: api_gears.png
---

## Facebook API Authentication Tokens

[Last week]({% post_url 2015-05-14-rails-and-facebook %}) I was glad to finally have progress with Facebook 
integration and Calendar Events.  Figuring out that you have to request additional permissions if you’d like to see the **user_events** didn’t 
take too long to figure out.  Though it is made more confusing by the face that all the [Koala](https://github.com/arsduo/koala) documentation 
shows a simple example of calling the **get_connection** method with an ‘events’ argument.
<!--more-->

Sure enough that does work.  The catch is that it works when you copy and paste the **Access Token** from the handy 
[Graph API Explorer](https://developers.facebook.com/tools/explorer/) tool Facebook provides.  This takes me to the different levels of Facebook authentication.


## Facebook Authentication Levels

As spelled out very clearly (once you take the time to carefully read the docs) on the [Access Tokens](https://developers.facebook.com/docs/facebook-login/access-tokens) 
page there are four different levels of authentication possible.

My confusion happened because, though I knew that there were separate levels for User authentication and App authentication, I thought authenticating with my 
Application key would give me the same results as authenticating as a User. 

Obviously this is not the case, and when you stop and think about it, it makes sense that it works this way.  Creating a benign web application to gather events 
from local groups accessing a user’s Events seems like a good thing.  I can totally see how an app accessing my Facebook info at random times can be a bad thing though.

## Facebook Events

My current solution to the problem of syncing Facebook Events is to fire off a *Active Job* thread when the user logs in and record the time things were synced.  

The job will only sync events that have an owner with the same name as a BCN Community and the user is part of that community.  At the moment the script 
checks that the sync happened over an hour ago before running.

Going forward I think [subscribing](https://github.com/arsduo/koala/wiki/Realtime-Updates) to the events once they’re created is really the way to go.

## Conclusion

After all this work getting things where I need them I now need to go back and write some tests for Facebook authentication.  Gonna be fun.

Party On!
