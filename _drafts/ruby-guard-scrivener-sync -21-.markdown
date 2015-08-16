# Syncing Scrivener Files 

## Scrivener Great, but…

I recently bought a license for [Scrivener](https://www.literatureandlatte.com/scrivener.php) because there was a great deal on [AppSumo](http://www.appsumo.com) a few weeks ago.  I bought it because I’d heard that a lot of writers, well people that write full time for a living, use it to organize their projects.  Since I’ve had a few ideas for books, and I’m writing these blog posts, I thought “hey self… why not buy a non-open source program if it helps you write more?”, and the rest is history.

One thing I’d really like to be able to do from Scrivener, and maybe you can I just don’t know how to do it, is to run a command from, or open a terminal, from inside Scrivener.  Since using [RubyMine](https://www.jetbrains.com/ruby/) and friends I’m used to having a terminal window open at the bottom of the program.  Why can’t Scrivener do the same thing?

We’ll move forward on the assumption that Scrivener indeed can’t open a terminal window, or execute an arbitrary command from a button, and use a Ruby script to sync the files in Scrivener **Drafts** with a **_drafts** directory that is part of a [Jekyll](http://jekyllrb.com/) site.

## Setup Scrivener Sync

Scrivener has a great “Sync to external folder” ability that we will use to copy **Draft** files into the **_drafts** directory of the Jekyll site.

To setup external folder sync:

* Click “File” in the main menu.

* Hover on “Sync” > click “with External Folder…”

* In the popup click the “Choose” button to browse to the folder you want to sync to.

* Make sure the “Sync the contents of the Draft folder” is checked in the “Options” section.

* In the “Format” section choose “Plain Text” for the “Format for external Draft folder” folder option and for the “ext:” field type in **”markdown”** (though you can also do md, or any other extension if you’re not saving as a Markdown file).

* I left all the other options as the defaults, but it’s probably worth playing around with them to see what other options can be useful for your workflow.

* Finally, the “Sync” button to export the “Draft” documents to your specified folder.

 

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

As you can see we’re not just going to install Guard, but the [guard-copy](https://github.com/marcisme/guard-copy) plugin as well.  There are plugins for Guard to do many common tasks.  Do a search on Google, or on Github itself, to find one that can do what you’re trying to accomplish.

Then in a terminal execute:

```

bundle install

```

Another thing I like to do is to *”binstub”* guard with bundle. This basically creates a *bin/guard* file in the current directory and you can then run ```bin/guard``` instead of the full ```bundle exec guard```.  It’s  a nice shorthand way to do things.

## Guardfile and Running Guard

Sort of like the old school (and still very awesome) **make** utility Guard uses a type of config file to tell it what to do.  In Guard’s case the file you want to create is named **Guardfile**.  The Guardfile can also be created and initialized with a plugin by executing:

```

bin/guard init copy

```

This will create the Guardfile and add a task for **guard-copy**, or if you already have a Guardfile the code will be appended to the bottom.  Edit the Guardfile copy task to have:

```

guard :copy, :from => '_drafts/Draft', :to => './_drafts' do

  watch(%r{^(.*)})

 end

```

This will copy all the files from the **_drafts/Draft** folder into the **_drafts** folder.  Then you can do some additional edits if you like and when complete move the file into the *_posts* folder for final publishing.

With all of this setup done, run **guard** in a terminal with:

```

bin/guard

```

## Conclusion

This may be a little overkill for simply moving some files around after exporting them from Scrivener, but I think it makes my Jekyll site files a little more organized.

Though after drafting this post I realize that I’ll have to rename and move the file anyway when I want to publish it.  So does it really matter if the draft file is in *_drafts*, or if it’s in *_drafts/Draft*?

I think so because I want to commit the files in _drafts to Github, but maybe not the ones in _drafts/Draft…

I guess I’ll try some things out and see what works best.  Writing this did give me the chance to learn Guard which I imagine will come in handy down the road, so I have a very positive attitude about it.

Party On!