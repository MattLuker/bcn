# Rails Image Assets in CoffeeScript

## SASS Gets It

There are a couple of handy [helpers](http://guides.rubyonrails.org/asset_pipeline.html#css-and-sass) for image assets in the Rails Asset Pipeline, but there wasn't anything similar for pure CoffeeScript files that I could find.

I did come across [this great post](http://dennisreimann.de/blog/referencing-rails-assets-in-coffeescript/) about the problem and pretty much copies the solution Dennis came up with.

Though, as the [documentation](http://guides.rubyonrails.org/asset_pipeline.html#javascript-coffeescript-and-erb) states, if you make your CoffeeScript files also *.erb* files then you can use the ```<%= asset_path('image.png') %>``` tag.  Though this is handy I think Dennis' solution is also great.

## One Coffee Erb File to Rule Them All

Instead of renaming each of my CoffeeScript files *script.coffee.erb* I just created a new one named *helpers.js.coffee.erb* in my *app/assets/javascripts* directory.  Feel free to name it however you wish.  The great thing about the Asset Pipeline is that adding things in one file makes them available in every other file... well mostly.

Here's the contents of [helpers.js.coffee.erb](https://github.com/asommer70/bcn/blob/master/app/assets/javascripts/helpers.js.coffee.erb):

```
<%
imgs = {}
Dir.chdir("#{Rails.root}/app/assets/images/") do
  imgs = Dir["**"].inject({}) {|h,f| h.merge! f => image_path(f)}
end
%>

window.image_path = (name) ->
    <%= imgs.to_json %>[name]
```

The magic is happening inside the *erb* tags which looks up an asset using Ruby, then the **window.image_path** property is set to a function which returns the asset's path.

Pretty slick!

## Conclusion

I agree with Dennis having little helper functions in one file feels a lot cleaner to me.  I guess I don't like *erb* tags cluttering up my good clean CoffeeScript either.

I like my CoffeeScript like I my coffee... Black and To The Point!

Not entirely sure what that means, but it sounds good in my ear balls.

Party On!