# Installing Ruby, Rails, and Passenger on Ubuntu (an Admin's Guide)

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



