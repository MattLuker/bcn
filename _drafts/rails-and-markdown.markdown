# Markdown in Rails, Yes Please!

##  I Love Markdown

I remember the first time I installed a [Mediawiki](https://www.mediawiki.org/wiki/MediaWiki) instance and started creating my first pages.  I enjoyed the wiki syntax was a fast way to create HTML pages.  Well that was nothing compared to how I feel about [Markdown](http://daringfireball.net/projects/markdown/).

For me there’s no better way to “shorthand” HTML then Markdown.  It gives you great styles with very concise syntax and it’s very quick to learn.  I mean even if you’ve never written an ounce of HTML, you can still jump right in with Markdown and not fear drowning.

Don’t get me started on blog platforms like [Ghost](https://ghost.org/).  I love writing in a Ghost blog so much better than writing in a WordPress blog.  Though there are plugins that will set things up very similar to how Ghost works.  Also, great writing this blog using [Jekyll](http://jekyllrb.com/) that understands markdown.  For quite a while my main Markdown editor has been [MacDown](http://macdown.uranusjr.com/), but recently I’ve been using [Scrivener](https://www.literatureandlatte.com/scrivener.php) since picking it up on an AppSumo deal.

Anyhow, we’re going to dive in and setup a *textarea* field on Rails to save and display Markdown.  Woo!

## The Backend

To save and understand Markdown we’re going to install the [redcarpet](https://github.com/vmg/redcarpet) gem.  This allows us to parse, save, and display Markdown inside Ruby (and Rails).  In your **Gemfile** add:

```
gem 'redcarpet'
```

Then bundle it up:

```
bundle install
```

Next, define a **markdown** method inside the *app/helpers/application_helper.rb* files:

```   def markdown(text)     markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,                                        no_intra_emphasis: true,                                        fenced_code_blocks: true,                                        disable_indented_code_blocks: true,                                        autolink: true,                                        tables: true,                                        underline: true,                                        highlight: true                                       )     return markdown.render(text).html_safe   end
```

Things should now be ready for marking down.

For more information check out the excellent [Railscast](http://railscasts.com/episodes/272-markdown-with-redcarpet) on Markdown and Redcarpet.

## The Frontend

With all the legwork done we can use our simple helper method inside the *erb* templates like this:

```
<%= markdown(@user.bio) %>
```

This example is from the [BCN](https://github.com/asommer70/bcn) project where we also used it for Post, Organization, and Community description fields.  The **markdown** method will display any Markdown syntax as it’s HTML.  Which is very cool.

One thing you might need to look out for is if you’re displaying the same fields in multiple ways for example using the **truncate** method to only display part of a Post in the Post *index* page.  If you don’t add the markdown method to that template you can display the raw Markdown text instead of the rendered HTML.  

I used this goodness to make things look good:

```
<%= truncate( strip_tags( markdown(post.description) ), length: 50) %>
```

As you can see the **strip_tags** method helps to remove the HTML tags after Markdown has converted the plain text.  Sort of complicated, but once you do it once you can use it anywhere.

## Conclusion

Markdown is good, use Markdown.

I kid, I kid.

Using markdown in the BCN project allows us to easily format long text blocks as well as embed additional images, videos, etc.  I hope once people start using the site it will be as easy for them as it was for me.

Party On!