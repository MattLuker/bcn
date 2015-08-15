# Syncing Scrivener Files 

## Scrivener Great, but…

I recently bought a license for [Scrivener](https://www.literatureandlatte.com/scrivener.php) because there was a great deal on [AppSumo](http://www.appsumo.com) a few weeks ago.  I bought it because I’d heard that a lot of writers, well people that write full time for a living, use it to organize their projects.  Since I’ve had a few ideas for books, and I’m writing these blog posts, I thought “hey self… why not buy a non-open source program if it helps you write more?”, and the rest is history.

One thing I’d really like to be able to do from Scrivener, and maybe you can I just don’t know how to do it, is to run a command from, or open a terminal, from inside Scrivener.  Since using [RubyMine](https://www.jetbrains.com/ruby/) and friends I’m used to having a terminal window open at the bottom of the program.  Why can’t Scrivener do the same thing?

We’ll move forward on the assumption that Scrivener indeed can’t open a terminal window, or execute an arbitrary command from a button, and use a Ruby script to sync the files in Scrivener **Drafts** with a **_drafts** directory that is part of a [Jekyll](http://jekyllrb.com/) site.

## Setup Scrivener Sync

Scrivener has a great “Sync to external folder” ability that we will use to copy **Draft** files into the **_drafts** directory of the Jekyll site.

To setup external folder sync:

* Click “File” in the main menu.

*

## Enter the Guard

To better accomplish this, and maybe it’s because I’ve started using more tools like [Gulp](http://gulpjs.com/) and [Sass](http://sass-lang.com/), we’ll run a [Guard](https://github.com/guard/guard) service to watch the files in Scrivener and copy them over when there are changes.

Should be simple.

## Install Guard

Guard is closely tied with [Bundler](http://bundler.io/) we need to edit the **Gemfile** for our Jekyll site.  Add the following to the bottom of the file:

```

group :development do

   gem 'guard'

   gem 'guard-copy'

end

```

Then in a terminal execute:

```

bundle install

```

Another thing I like to do is to *”binstub”* guard with bundle. This basically creates a *bin/guard* file in the current directory and you can then run ```bin/guard``` instead of the full ```bundle exec guard```.  It’s  a nice shorthand way to do things.