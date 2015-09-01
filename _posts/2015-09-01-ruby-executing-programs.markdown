---
title:  "Make it Run!"
date:   2015-09-01 14:30:00
layout: post
categories: ruby learning
image: executing_cover.jpg
---

## What Runs

Ruby is an interpreted language and that means we can use the **ruby** executable file to execute our scripts without any compiling and linking steps.  Basically you can take a plain text file with Ruby instructions in it and execute that puppy.

The other fun thing to do with Ruby is execute other programs from inside a Ruby script.  Usually you’ll use this for executing command line utilities and doing something with their output.  

<!--more-->

## Executing a Ruby Script

The simplest way to execute a Ruby script is to use the **ruby** interpreter executable directly:

```
/usr/bin/ruby test.rb
```

The above command uses the **ruby** interpreter installed in */usr/bin/ruby* which is usually the system default.  

On Max OS X and Linux distributions you can place a *shebang* character at the start of your file to tell the system which interpreter to use.  The shebang looks like:

```
#!/usr/bin/ruby
```

Bam! Ready to run…

Another way to point to your Ruby interpreter is to use the **env** utility. This is especially great if you’ve used a Ruby installer like **rbenv** or **rvm** to install an updated version of Ruby in a “non-standard” location.  To use **env** in your script shebang it with:

```
#!/usr/bin/env ruby
```

You can determine which version of Ruby is executing your script with this little nugget:

```
#!/usr/bin/env ruby
puts RUBY_VERSION
```

Also, if you’re using Mac or Linux you can set the script file as executable and run it with a good old **./test.rb**:

```
chmod 755 test.rb
./test.rb
```

This is particularly great if you’re executing a script a lot in the course of debugging a complex script.

## Executing External Programs with Ruby

The simplest way to execute a system command is to use **backticks** (’`’).  Using backticks will execute the command in a  subshell and return the result.  For example to get a list of files in the current directory:

```
files = `ls`
```

Not all that useful, but you now have a string of file names.

For more control over the output of a command you can use the **Open3.popen3** method:

```
in, out, error = Open3.popen3(‘ls’)
```

The method will populate the variables with the output of *stdin*, *stdout*, and *stderr* which is useful if you need it… I guess.

## Conclusion

There are more ways to execute a Ruby script and commands from within a Ruby script so if your needs aren’t met with this just dig further.

Sometimes quick and dirty is best.

Party On!
