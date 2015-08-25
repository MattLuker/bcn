# Pagination with Rails

## Gimme A Page

I’m not 100% sure, but I think the basis of all those fancy infinite scrolling websites, and apps, is a paginated list of something.  Could be images, blog posts, etc.  I do know that scrolling through a massive list of posts on a website is balls.

To solve this particular issue with [BCN](https://github.com/asommer70/bcn) I used the [will_paginate](https://github.com/mislav/will_paginate) gem.  There are other solutions to enable pagination in Rails, but **will_paginate** seemed popular and easy to integrate.

I imagine rolling your own wouldn’t be too difficult either.  But who wants to do all that extra work?

## Setting things Up

Grab the **will_paginate** gem by adding the following to your *Gemfile*:

```

gem ‘will_paginate’

```

Then in a terminal run:

```

bundle install

```

Blame! Things are ready for some code.

## Coding up the Pages

The first place I used pagination was on the *index* page of the Posts controller in BCN.  So in your controller adjust the **index** method to be similar to:

```

@posts = Post.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)

```

The main parts are the **paginate** method and the parameters.

* **page** is the page to retrieve.

* **per_page** is the number of objects you’d like to retrieve.

Now in your *view* (app/views/posts/index.html.erb in my case) add the following after your *”@whatever.each”* loop:

```

<%= will_paginate @posts %>

```

This will render a nice element with a list of page numbers with previous and next links to page through them.  All in all the default is pretty good.

## Foundation Pages

Because the BCN project is using [Foundation](http://foundation.zurb.com) for the frontend there is another gem to take pagination a little further.  Well it makes things look good in Foundation with a lot less effort on my part.

Install [will_paginate-foundation](https://github.com/acrogenesis/will_paginate-foundation) by adding this to you *Gemfile*:

```

gem ‘will_paginate-foundation’

```

And do the familiar ```bundle install```.  With the new gem good to go adjust the view to use a different renderer:

```

<%= will_paginate @posts, renderer: FoundationPagination::Rails %>

```

Pow! Things should now look great and use the Foundation classes.

## Conclusion

So glad there are great and wonderful people out there that share the code to do small things like pagination.  And others who build on that to share a solution to an even more niche group.

This process seems so simple that the idea of making some videos about it blasted into my mind balls.

Maybe…

Party On!