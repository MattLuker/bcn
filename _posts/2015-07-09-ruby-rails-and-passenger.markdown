---
title: "Installing Ruby, Rails, and Passenger on Ubuntu (an Admin's Guide)"
layout: post
date:   2015-07-09 14:30:00
categories: rails bcn
image: rails_passenger.jpg
---

## Admins are People Too

There are many ways to deploy Rails, but this one is mine.  Err, this is the one I learned and so far it's worked great.  I like being a Passenger on Rails.

Oh, I slay me.  This isn't a Rails development post per say, but if you are ready to deploy your Ruby on Rails application on Ubuntu 14.04 LTS, then this is one way to do it.

Hold onto your butts cause we're going to install the latest Ruby with rbenv, install Ruby on Rails via gems, and install and configure Passenger with Apache.

<!--more-->


## rbenv 

Install [rbenv](https://github.com/sstephenson/rbenv) from Github.  As per the documentation, clone the repo into ```~/.rbenv```:

```
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
```

**Note:** if you don't already have it install **git** before trying to clone the repository.  Use ```sudo apt-get install git``` to install the version that ships with Ubuntu.

Add **rbenv** to your path by appending the following to your *.bashrc* file:

```
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
```

Next, add *rbenv init* for shims and autocompletion (autocompletion is tops by the way):

```
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```

At this point the documentation suggests restarting your shell, or opening a new terminal, but you can also just use the **source** utility to refresh your *.bashrc*:

```
source .bashrc
```

To double check that things are setup use **type**:

```
type rbenv
```

There should be some output similar to:

```
rbenv is a function
rbenv ()
{
    local command;
    command="$1";
    if [ "$#" -gt 0 ]; then
        shift;
    fi;
    case "$command" in
        rehash | shell)
            eval "`rbenv "sh-$command" "$@"`"
        ;;
        *)
            command rbenv "$command" "$@"
        ;;
    esac
}
```


## ruby-build

But first we're going to need to install the *rbenv plugin* [ruby-build](https://github.com/sstephenson/ruby-build#readme).  

As with *rbenv* clone the **ruby-build** repository:

```
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
```

Let's take a look and see which versions of Ruby are available:

```
rbenv install -l
```

As you can see **rbenv install** (or ruby-build to be precise) gives quite a few options.  I'm going to grab the latest stable version of Ruby which as I write this is **2.2.2**.   

## Ruby

Let's get down to the business of installing the latest [Ruby](https://www.ruby-lang.org/en/) version.

Before we can download and compile the latest Ruby using **rbenv**, there are a few packages we'll need if you don't already have them installed.  Using *apt-get*:

```
sudo apt-get install curl build-essential zlib1g-dev libssl-dev nodejs
```

* **curl** utility is used by *rbenv* to download the Ruby source.
* **build-essential** package will get a C compiler and other utilities needed to build software on Ubuntu.  
*  **zlib** is needed for Ruby to enable *zlib* compression support
*  **libssl-dev** is used for encryption.  
*  **node.js** is used to build the Rails JavaScript assets.


Now install Ruby with:

```
rbenv install 2.2.2
```

You should see something similar displayed:

```
Downloading ruby-2.2.2.tar.gz...
-> http://dqw8nmjcqpjn7.cloudfront.net/5ffc0f317e429e6b29d4a98ac521c3ce65481bfd22a8cf845fa02a7b113d9b44
Installing ruby-2.2.2...
```

This may take a while so I suggest working on another project, or taking a break even.  Studies show that focus and performance improves with frequent breaks throughout the day.  Not sure which studies show that, but it's out there on the Internets...

After the install finished (remember it can take some time) view the available version with **rbenv**

```
rbenv versions

  2.2.2
```

Next, rehash *rbenv*:

```
rbenv rehash
```

Finally, set the **2.2.2** version of Ruby to be *global*

```
rbenv global 2.2.2
```

To see the new version of Ruby use:

```
ruby -v
```

## Ruby on Rails

Time to install everyone's favorite web framework.  [Ruby on Rails](http://rubyonrails.org/) is one of the most popular web frameworks and the "killer app" that brought Ruby to a lot of developers.

Before we install Rails, I'm going to create  **.gemrc** file in my home directory in order to skip installing documentation:

```
gem: --no-document
```

Since I'm setting up a server the gem documentation isn't that important to me, but if you're setting things up on a development workstation you may want to skip that and install the documentation for your viewing pleasure.

Using Ruby **gem** let's install Ruby on Rails:

```
gem install rails
```

The next gem we'll need, because I've quite a few external libraries in my Rails project, is [bundler](http://bundler.io/).  Bundler keeps track of which gems you use in a Ruby project and makes things easier to setup between different machines.

```
gem install bundler
```

We're now all set with Ruby on Rails and you can either create  new Rails project, or clone the repository of an existing project.

## Existing Rails Project

I'm going to setup a "production" install of the [BCN Rails](https://github.com/asommer70/bcn) project by first cloning the repository locally:

```
git clone https://github.com/asommer70/bcn.git
```

Next, install the dependency gems with **bundler**:

```
bundle install
```

It's very possible that some gems will fail to build due to missing dependencies.  In cases like this it's usually easy to find the missing package with ```apt-get search```, but sometimes it's not obvious.  If you can't find the package with apt-get a quick Google search should point you in the right direction.

Keep running ```bundle install``` after any failed gem builds until it completes without errors.

Once all the gems are installed migrate the database:

```
RAILS_ENV=production bin/rake db:migrate
```

I like to precompile the assets as well:

```
RAILS_ENV=production bin/rake assets:precompile
```

Things should now be ready to setup Apache and serve our project to the web.

## Passenger

Not sure if I'm getting old, but when it comes to web servers my go to server is good ol' Apache.  I've used Nginx a few times, well more of tried it out, and I have no doubt that it does a fine job.  For me Apache is **the** web server.

In light of this fact we're going to setup Phusion Passenger according to the [Apache Documentation](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#installation).

### Installation

First off, add the Passenger APT repository:

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
```

Then add the HTTPS support:

```
sudo apt-get install apt-transport-https ca-certificates
```

And create the config file ```/etc/apt/sources.list.d/passenger.list```:

```
# Ubuntu 14.04
deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main
```

Adjust the config file permissions and update *apt-get*:

```
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get update
```

Install the package:

```
sudo apt-get install libapache2-mod-passenger
```

Now restart Apache:

```
sudo service apache2 restart
```

Alright, Passenger is now installed and ready to be configured for your Rails app.  Woo!

### Configuration

I like to the Ubuntu (and Debian) convention of creating separate *VirtualHosts* for each site on an Apache server. So I'm going to create a new config file in ```/etc/apache2/sites-available/bcn.conf``` and clone, or move, my Rails app to ```/var/www/```. 

That way the *DocumentRoot* option won't be pointing to my home directory on the server. 

Create the file and add:

```
<VirtualHost *:80>
  ServerName bcn.thehoick.com
  DocumentRoot /var/www/bcn/public

  <Directory /var/www/bcn/public>
    Allow from all
    Options -MultiViews
    Require all granted
  </Directory>
</VirtualHost>
```

Because we're using an **rbenv** version of Ruby we need to tell Passenger where it is.  At least that has been my experience because without specifying it Passenger uses the gems installed with the system Ruby (usually version 1.9.3, or something similar) instead of the new versions.

Edit */etc/apache2/mods-available/passenger.conf`*:

```
<IfModule mod_passenger.c>
    PassengerRoot /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini
    PassengerDefaultRuby /home/$YOUR_HOME_DIRECTORY/.rbenv/shims/ruby
 </IfModule>
```

**Note:** you could also specify a specific deployment user if you don't want to use your user account to setup the Rails app.

Finally, enable the site and restart Apache:

```
sudo a2ensite bcn.conf
sudo service apache2 restart
```

If all goes well you should see an **OK** message that Apache has restarted.  Check the **var/log/apache2/error.log** file for any errors.

Now the moment of truth, browse to the new server and hopefully you will see the Rails app you've been working on just like in development.

If you see a Passenger error page take a look at the error log:

```
tail -f /var/log/apache2/error.log
```

There should be some output that will point you in the right direction.

## App Updates

From here on out any updates to you app can be handled with a few commands:

```
cd /var/www/$APP_ROOT
git pull
RAILS_ENV=production bin/rake assets:precompile
sudo service apache2 restart
```

If you make changes to the database you may have to also run the migrations:

```
cd /var/www/$APP_ROOT
git pull
RAILS_ENV=production bin/rake db:migrate
RAILS_ENV=production bin/rake assets:precompile
sudo service apache2 restart
```

And POW! your updates will be live.


## Conclusion

Hopefully you now have a production Rails app up and running and hopefully things are working fast and looking great!

There are a lot of other ways to deploy production Rails apps and I'm sure some of them might even be easier.  I found this method useful because I can ensure that my development Ruby and gem versions match the server's versions.

Also, be sure to check out the Passenger documentation cause there are a lot of options for fine turning as well as additional things that you may want to configure.

Party on!

