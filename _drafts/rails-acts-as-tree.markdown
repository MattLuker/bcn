# Acts as Tree Rails Style

## The Gem

A parent child relationship can be very complicated.  Sometimes the parent likes to lay on the guilt when the child moves a thousand miles away across half the continent... oh wait.

I wanted to take about a parent child relationship in Rails and not my own baggage.

Setting up a parent-child for your Rails models is pretty easy thanks to the [acts-as-tree](https://github.com/amerine/acts_as_tree) gem.  There are other Ruby libraries out there that can accomplish the same thing, but this is one of the first ones I tried.  And you know what things worked out great.

## Installation and Configuration

 Install the **acts_as_tree*  gem by adding this line to your *app/Gemfile*:
 
```
 gem 'acts_as_tree'
```

Then hammer in a: ```bundle install``` (or maybe just ```bundle``` whichever you prefer).

Next, setup the model to be act like a tree and set an attribute to order them by:

```
class Comment < ActiveRecord::Base
  acts_as_tree order: 'created_at'
end
```

In my case I wanted to add child Comments to a Comment and display them in the order they were received.

## Controlling Those Rowdy Children

With the model setup, the **acts_as_tree* gem gives you some cool methods like **children** that you can loop through.  I used it to pass the same partial I used in the Post show view to display a Comment's comments:

```
<%= render 'comments', {comments: comment.children} %>
```

I'd like to think I completely understand how it works.

Also, in the controller you can scope a new comment using the **children**:


```
      comment = @parent_comment.children.new(comment_params)
```

Another great feature is the **root** method.  This lets you get the first ancestor, or well the *root* object, which can have some useful attributes:

```
comment.root.post.user
```

Like user information.


## Conclusion

In my user of **acts_as_tree** I know I didn't DRY my code up as much as I could have.  It's really pretty damp if I'm gonna be truthful, but I found it quite easy to create nested Comments for the [BCN Rails](https://github.com/asommer70/bcn) Post model.

So if I can hack something in, that makes me happy.

Party On!