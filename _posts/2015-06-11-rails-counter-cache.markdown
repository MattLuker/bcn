---
layout: post
title:  "Poor Man's counter_cache for HABTM"
date:   2015-06-11 07:00:00
categories: bcn rails
author: <a href='https://twitter.com/asommer' target='_blannk'>Adam Sommer</a>
image: counting.png
---

## Counters for Me, but not for You

Rails has [this](http://guides.rubyonrails.org/association_basics.html#options-for-belongs-to) very handy **counter_cache** option for a **belongs_to** association.  What counter_cache does is automatically increment, and decrement, a counter field when a object is added to the corresponding **has_many** model.

All well and good for a **has_many**.  So glad that they get all the fun.
<!--more-->

In the case of the [BCN Rails](https://github.com/asommer70/bcn) project all the **has_many** associations are also **belongs_to**.  As it turns out **has_many :through** did have a **counter_cache** option in the past.  However after several bugs, [like this one](https://github.com/rails/rails/issues/3903), I guess they deprecated the feature and now it's not an option.

I learned this after changing my **has_and_belongs_to_many** associations to **has_many :through** and trying pretty hard to get a counter_cache working.  I guess I'm not bad ass enough, or maybe I'm just balls tired, cause I wasn't able to get things working.

## Changing the Stripes of an Association

Changing a **habtm** association to a **has_many :through** is surprisingly easy.  First, I renamed my join tables using a migration:

```
    rename_table :communities_users, :community_users
    rename_table :communities_posts, :community_posts
```

In this case I chose a singular first name cause it sounded better.

Next, create a new **CommunityPosts** model:

```
class CommunityPosts < ActiveRecord::Base
  belongs_to :communities
end
```

Then adjust the *Community* model for the new association:

```
has_many :posts, through: :community_posts
```

And Bob's Your Uncle!

All of the methods work the same as a **habtm** association, and you get the added benefit of being able to add additional attributes to the join model if you'd like.  I can see where this might be useful, but I couldn't find a reason in this project so I switched back to a good ol' **habtm**

## Counting Caches the Hard Way

Since the baked in goodness of **counter_cache** isn't going to work out for me, I brute forced it (Rrrraaarrrrr that's my brute sound) using the **:before_add** and **before_remove** options for the **habtm** association.  At least using this methods feels a little forced to me.  Maybe I'm being too sensitive.

In the Post model add the options:

```
  has_and_belongs_to_many :communities, before_add: :inc_posts_count, before_remove: :dec_posts_count
```

And create two methods (**private** methods in this case):

```
  private
  def inc_posts_count(model)
    puts "model.inspect: #{model.inspect}"
    Community.increment_counter('posts_count', model.id)
  end

  def dec_posts_count(model)
    puts "dec_posts_count: #{model.inspect}"
    Community.decrement_counter('posts_count', model.id)
  end
```

Now when you remove a Post from a Community, or add one, the **posts_count** field gets incremented or decremented depending on the action.

Also, don't forget to add the **posts_count** field inside a migration if you haven't done that yet.  Maybe should have mentioned that earlier.

## Conclusion

It would be nice for Rails to automagically take care of the **counter_cache** for me, but I understand how things can get tricky pretty quickly when your dealing with associations.

Oh ya, the reason for all this counting and caching is to setup an easy way to sort Communities by the number of Posts **+** the number of Users.  I'm using that as a rough estimate as to the popularity of a Community.

Party On!
