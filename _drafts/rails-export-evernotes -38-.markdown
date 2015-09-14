# Export Evernote Notes With Rails

## Notes The Backbone of Projects

I’ve had an [Evernote](https://www.evernote.com/referral/Registration.action?sig=ced560945d99f9c099d9282af6b8e21b&uid=11392509) account for a long time, but it wasn’t until I got a Mac and installed the desktop client that I discovered why a lot of people like Evernote.  Using the web interface from Linux workstations is one thing, but using the desktop client to keep track of ideas, projects, etc takes notes to the next level.

At least it did for me and the second biggest advantage is having access to everything on Android and iOS.

There is one big **but** though.  Having all that information in someone else’s servers and databases doesn’t always sit well.  After all everything comes to an end.  Is Evernote going to end anytime soon? I highly doubt it.  I think the Feemium model they have is great and at a price point that a lot of people don’t mind paying.  Not to mention that fact that the company is founded ran by some super smart cats.

Being such a great company Evernote has a great REST API you can use to develop on top of their platform, so we’ll whip up a Rails app to export all our precious notes so that we can back them up and maybe serve them on our own server.

## Getting Rails Setup