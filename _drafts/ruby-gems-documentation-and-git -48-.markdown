# Ruby Gems, Documentation, and Git

## Gems

I’m not sure of the origin of packages, probably sometime back in the 60s, but they are super useful at this time.  There are package managers for practically every platform out there, and every language now seems to have their own.  

This is both good and bad.

From a Linux distribution developer’s standpoint it can be a hassle to package up apps, libraries, etc that are distributed via a language specific package management system like **npm** or **pip** (for JavaScript and Python respectively).

Ruby isn’t left out in the package manager.  Most Ruby libraries, frameworks, etc can be downloaded installed specifically for the version of Ruby you’re running via [RubyGems](https://rubygems.org/).  Gems are super easy to install and begin using the code in your own apps.

Gems are the mechanism that allows Ruby developers to stand on the shoulders of giants… Bum Bum Bum!!

(Those are drums at the end)

### Using Gems

There are few common commands with gems.  The ```gem``` command line utility has great help with the **-h** option:

```

gem -h

```

You can also get help for a specific command by using ```gem help $command``` for example:

```

gem help install

```

Will display the options for the ```gem install``` command.  To get a list of all available gem commands enter:

```

gem help command

```

Figuring out what version of **gem** you’re working with is also useful:

```

gem -v

```

To install a gem package use:

```

gem install sinatra

```

The above example will install the [Sinatra](http://www.sinatrarb.com/) web framework.  Replace **sinatra** with the gem name you’d like to install.

To get a full list of gems installed for the version of Ruby you’re running run:

```

gem list

```

The list can get pretty large over time so a quick tip is to pipe the output through **grep** if you’re looking for a specific gem:

```

gem list | grep sinatra

```

Also, notice that the output of the ```gem list``` command also displays the gem’s version.

To see what’s in a gem use the **contents** command:

```

gem contents sinatra

```

To update a gem, or all your gems, run:

```

gem update

```

And to remove a gem:

```

gem uninstall sinatra

```

Remember replace **sinatra** with the name of the gem you’d like to uninstall.

### .gemrc

For production systems, or servers, you might not want to install the documentation locally.  By default RubyGems will install **ri** and **rdoc** formats of the gem’s documentation.  To disable this, and make installing gems quite a bit faster, create a file in your home directory named **.gemrc** with these contents:

```

gem: --no-document

```

Now the documentation install step will be skipped.

## Ruby Documentation

If you do want the local documentation you can read the docs locally in a terminal with the **ri** utility:

```

ri

```

The **ri** utility is similar to **irb** and enters you into an interactive terminal.  You an now lookup documentation for Ruby objects, like **File**, by typing their name. You can also lookup the documentation for an object directly:

```

ri File

```

The Ruby documentation is also [online here](http://ruby-doc.org/core-2.2.3/) for the core and standard library.  The [RubyGems](https://rubygems.org/gems/sinatra) site is also a good place to find documentation specific to a gem.

The site where I get the vast amount of documentation is on [Github](https://github.com/) itself.  Often the only place a particular gem is documented is on the projects Github page.  For example take a look at the doc goodness for [Sinatra](https://github.com/sinatra/sinatra)

Between *ri*, the Ruby standard documentation, and Github there’s not a lot you won’t be able to find.

## Git

Version control for you projects is pretty much mandatory in my humble opinion.  Working without version control is border line reckless.

Since being first developed by Linus Torvalds himself [Git](https://git-scm.com/) has become probably the most popular version control system available.  It’s certainly one of the best as far as speed, features, and popularity.  So let’s go over the most common ways to use **git**.

To setup a git **repository** for you project, open a terminal and make sure you’re in the project’s directory then enter:

```

git init

```

Now import the files in the directory:

```

git add .

```

And finally commit the files to the new repo:

```

git commit -m “Initial Import.”

```

The **-m** option sets the commit message. If you don’t use the **-m** followed by a quoted message git will open a text editor in the terminal.  I usually use the -m with a short message describing the commit.

Now proceed to develop your application as normal.  When you get to a good place, or complete that next awesome feature, do another commit with:

```

git commit -am “New awesome feature is done.”

```

The **-am** is shorthand for **all** and again the **-m** is for **message**.  This will commit all previously imported file changes.  If you create a new file in your project you will need to do a ```git add $filename``` to import it into the repo.  In my projects I frequently do:

```

git add .

git commit -am “commit message…”

```

That way there’s not doubt if a file has been imported or not.  

Another very useful git command is **status**:

```

git status

```

This will show you which files have changes and which files have yet to be added (if any). 

To learn more about Git the free [Git Book](https://git-scm.com/book/en/v2) is a great resource.  Also, there are great videos on [Youtube](https://www.youtube.com/results?search_query=git) on how to use git.

### Remote Git

Getting your code into version control is a great first step and will let you recover a file if you make a mistake.  That doesn’t save you from hardware failure however.  Just creating a new repository and importing files only saves those files into the local repository.  It’s far better to get those files into a remote repository in case disaster happens.  It’s also very useful if you use multiple workstations for development. 

To setup a remote repository use the **git remote** command (from the project directory):

```

git remote add origin greenback:~/work/test

```

This example will add a remote repository for the remote name of **origin** to a computer named **greenback** (a local workstation on my LAN) in the **~/work/test** directory.  Now you can **git push** the files to the remote repo:

```

git push origin master

```

This will **push** the local code to to the remote repo named **origin** using the **master** branch.  And now your files are copied to another machine.

The final frequently used git command with remote repos is **git pull**.  If you, or another developer, has made changes to the files in a remote repository, or pushed their changes to the remote repo, you can get those changes with:

```

git pull origin master

```

**Note:** git will output a message to use the **—set-upstream** option to allow you to only have to enter ```git pull```.  I recommend entering those commands cause it makes things simpler.

Using a Git repository on the Internet is also a great way to backup your project and share your code.  [Github](https://github.com/) has become the most popular place to host code since Source Forge.  It’s free to hose unlimited repositories of [Open Source](https://github.com/pricing) projects and they have good pricing plans for any number of private repositories.  Also, the features of Github make collaboration super easy.

An alternative to Github that you can host yourself is [Gitlab](https://about.gitlab.com/).  It’s pretty straight forward to get installed on an Ubuntu Server and they also offer [hosted repositories](https://about.gitlab.com/pricing/) at a pretty good price.  Running your own Gitlab gives you a nice web front-end for your project repositories.

## Conclusion

Hopefully things are more clear on finding additional Ruby libraries, documentation, and using version control.  There’s really a lot of great options for finding things with Ruby documentation and sharing your code with the world.

Party On!