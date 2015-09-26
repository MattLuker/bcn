# Git Commits with GUI and Ruby

## GUI?

Of the many ways to create a graphical interface with Ruby I like the web the best, heh.  Sometimes it’s fun to have a native GUI though.  In earlier posts I covered a way to use Guard to watch for file changes in a subdirectory of the **_drafts** directory of a  Jekyll blog.  Now I’d like to have a window popup and ask me for a git commit message then automatically commit the latest version to the repository.

I would just script it with a canned message, but sometimes it’s nice to customize things for historical purposes.  I suppose.

## Sinatra…

For a native GUI there are some solutions like [Shoes](http://shoesrb.com/), but we’re not going to use a native GUI solution.  Oh no.

We’re going to create a very small web application and serve it with [Sinatra](http://www.sinatrarb.com/).  Sinatra is a small library, or DSL (Domain Specific Language if you prefer) for developing web applications in Ruby.  Sort of like a minimal Ruby on Rails, or like Flask in Python, Sinatra let’s you quickly setup  web server and do fun things with Internet protocols.

## Install Some Gems

This little script requires a few gems to accomplish what I’d like to accomplish.  Whip open a terminal and enter:

```

gem install sinatra sinatra-contrib launchy

```

The **sinatra** gem is the base Sinatra library, the **sinatra-contrib** gem is a collection of Sinatra extensions that are very useful, and the **launchy** gem allows you to open an application from Ruby.  In this case we’ll open a new browser window with the URL for our Sinatra web app.

## Script it Up

The web page is pretty simple.  We’ll display a form, have a Sinatra route block to handle the form HTTP POST (which will also perform the **git commit**), and we’ll display the results of the git commit.

Here’s the script:

```

#!/usr/bin/env ruby

#

# Use Shoes dialog to get git commit message, then commit and push repo.

#

require 'sinatra'

require 'sinatra/reloader'

require 'launchy'

enable :sessions

get '/' do

  html = <<FORM

  <br/><br/>

  <div style="margin: 0 auto; max-width: 700px;">

    <h4>Enter a Commit Message:</h4>

    <form action="/commit" method="post">

      <textarea name="message" cols="50" rows="10"></textarea>

      <br/><br/>

      <input type="submit"/>

    </form>

  </div>

FORM

end

post '/commit' do

  puts params[:message]

  session[:commit] = `git add . && git commit -m "#{params[:message]}"`

  session[:push] = `git push`

  redirect to('/results')

end

get '/results' do

  html = <<HTML

  <br/><br/>

  <div style="margin: 0 auto; max-width: 700px;">

    <h4>Results:</h4>

    #{session[:commit]}

    <br/><br/>

    #{session[:push]}

    <br/><br/>

    <a href="/">Back</a>

  </div>

HTML

end

Launchy.open("http://localhost:4567")

```

Notice the require statements at the top.  We’re requiring both **sinatra** and **sinatra/reload**.  The **sinatra/reloader** is form the **sinatra-contrib** gem and allows the server to “refresh” changes in the field without having to manually stop and start the server.  Of course the **launchy** require is what allows us to use the **Launchy.open** method at the bottom of the script.

Sessions are then enabled to give us a place to save the output from the **git** commands between requests.  The **get ’/‘ do** block sets up the site “index” which simply outputs the contents of the **html** heredoc. 

Don’t worry if you’re not familiar with HTML cause the **post ‘/commit’ do** block takes the results of the textarea tag and uses that as an argument to the **git commit** command line utility called using back ticks.

The results of the **git commit** (and push) are stored in the **session[:commit]** and **session[:push]** variables.  Then the browser is redirected to the **get ‘/results’ do** block which output some HTML with a status message.

Boom!

## Guard 

In the [Syncing Scrivener Files](http://devblog.boonecommunitynetwork.com/ruby-guard-scrivener-sync/) post we setup Guard to copy files into the **_draft** folder of the Jekyll site.  Having Guard fire up the **git_commit.rb** script is fairly straight forward. 

First, add the **guard-process** gem to the **Gemfile** so it looks like:

```

group :development do

  gem 'guard'

  gem 'guard-copy'

  gem 'guard-process'

end

```

Next, add the following to the end of the **Guardfile**:

```

guard 'process', :name => 'git_commit', :command => './git_commit.rb' do

  watch %r{_drafts/(.*)}

end

```

Copy **git_commit.rb** into the root directory of the Jekyll site and things should be good to go once your run the **bin/guard** command.

## Conclusion

There are some assumptions with this script.  The first one being that the directory you execute it in already has a git repository setup and a remote location configured.  This is pretty simple see the [Git Book](https://git-scm.com/book/en/v2) for more information on Git.  Also, that you name your script **git_commit.rb**.

Party On!