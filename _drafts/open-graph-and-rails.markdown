# Open Graph Data in Rails

## Open Graph Protocol

I've always found it cool when typing a link in Facebook (and G+) that it goes and fetches information about a link you paste into a comment or post field.  And doing it before I hit the button is icing on the cake.

For a long time I wondered how Facebook was grabbing that information.  Did it scrape the site using some fancy Ajax?  Did someone sit in a basement somewhere and wait for people to type in links, then go to the link and grab the text?  Ha, that would be funny.

At some point not too long ago Facebook, and I think a bunch of other "social" companies, put together a "protocol' for listing meta data about a website.  The idea being to make sharing the content that much easier.

So today we have [Open Graph](http://ogp.me/) and the world is a better place!

<!-more-->

## Setting Some Defaults

For the [BCN Rails](https://github.com/asommer70/bcn) project I setup some defaults in the **application.html.erb** layout file:

```
  <% if content_for?(:meta_og) %>
      <%= yield :meta_og %>
  <% else %>
      <meta property="og:title" content="Boone Community Network" />
      <meta property="og:type" content="website" />
      <meta property="og:url" content="http://boonecommunitynetwork.com" />
      <%= tag :meta, property: 'og:image', content: image_url('bcn_logo.png') %>
  <% end %>
```

Walking through the code, I used the very handy **content_for?** method to allow different views to override these settings. 

I setup some standard tags for:

* og:title
* og:type
* og:url
* go:image which also has a *content* attribute that calls the *image_url* method.

These tags and attributes seem to be a good base from what I can tell by reading the Open Graph documentation.  I may have missed some other useful ones, but they can always be updated down the road.

## Post Pages

The Post show page has some more customized tags:

```
<%= content_for(:meta_og) do %>
    <meta property="og:title" content="<%= @post.title %>" />
    <meta property="og:type" content="article" />
    <meta property="og:published_time" content="<%= @post.created_at.strftime('%Y-%m-%d %H:%M') %>" />
    <meta property="og:author" content="<%= @post.user.username if @post.user && @post.user.username %>" />
    <meta property="og:description" content="<%= truncate(strip_tags( markdown(@post.description) ), length: 50) %>" />
    <% if @post.image %>
        <%= tag :meta, property: 'og:image', content: "http://#{request.host}#{@post.image.url}" %>
    <% end %>
<% end %>
```
 
 This pages has **og:published_time**, **og:author** if the Post has a user and the user has configured a username, **og:description** which overrides the sites *meta*  description tag, and it sets the **og:image** to the Post's image if it has one.
 
 Also,  notice the **strip_tags** method around the **markdown** method that wraps the Post description then **truncates** it.  This makes the text look better when sharing if you're saving Markdown data.  At least I think it looks better.
 
## User Profile

The most logic to setup these tags for the BCN app anyway is the User profile page:

```
<%= content_for(:meta_og) do %>
    <meta property="og:type" content="profile" />
    <% if @user.username %>
        <meta property="og:title" content="<%= @user.username %>" />
        <meta property="og:username" content="<%= @user.username %>" />
    <% else %>
        <meta property="og:title" content="Anonymous User Profile" />
    <% end %>
    <% if @user.first_name %>
        <meta property="og:first_name" content="<%= @user.first_name %>" />
    <% end %>
    <% if @user.last_name %>
        <meta property="og:last_name" content="<%= @user.last_name %>" />
    <% end %>
    <% if @user.photo %>
        <%= tag :meta, property: 'og:image', content: "http://#{request.host}#{@user.photo.url}" %>
    <% end %>
    <% if @user.bio %>
        <meta property="og:description" content="<%= truncate(strip_tags( markdown(@user.bio) ), length: 50) %>" />
    <% end %>
<% end %>
```

Like the Post the User **og:description** has be wrapped in the markdown > strip_tags > truncate business.  I guess I could extract that into it's own method...  maybe some day.

Because there really aren't any required fields for BCN users they are each wrapped in if statements to not cause any rendering errors.

## Conclusion

Setting up Open Graph tags is pretty straight forward, it's basically the same as dynamically setting any *head* tags using Rails.

There is one "gotcha" thing with Rails and **Turbolinks**.  When browsing between pages the **head** section of the page isn't updated.  This is by [design](https://github.com/rails/turbolinks/issues/81#issuecomment-9261714) I guess so not sure if that will change anytime in the near future.  If you do a little searching there are some work arounds for this, but I didn't think it would be worth too much time and hinky code.  

Maybe if users complain about it, heh.

Party On!