# Git Commits with GUI and Ruby

## GUI?

Of the many ways to create a graphical interface with Ruby I like the web the best, heh.  Sometimes it’s fun to have a native GUI though.  In earlier posts I covered a way to use Guard to watch for file changes in a subdirectory of the **_drafts** directory of a  Jekyll blog.  Now I’d like to have a window popup and ask me for a git commit message then automatically commit the latest version to the repository.

I would just script it with a canned message, but sometimes it’s nice to customize things for historical purposes.  I suppose.

## Shoes…

For a native GUI the [Shoes](http://shoesrb.com/) gem will work great.  The interface we’ll use is pretty simple.  A text area and a “commit” button to start the commit.  To make things simpler we’ll then “echo” the commit message to the git command line utility and the use a “git push” to upload the commit to Github.

To start things off install the **shoes** gem:

```

gem install shoes

```