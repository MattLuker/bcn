#
# Replace Recent Posts on the home page with the next 5 after 30 seconds.
#
@scroller =
  update_posts: (page_number=2) ->
    console.log('Updating posts...')
    $.ajax
      url: '/api/posts?page=' + page_number
      success: (posts, status, jqXHR) ->
        # Put the array into an object for the Mustache template.
        posts = {posts, default_post_image: default_post_image}

        output = Mustache.render(scroller.template, posts, default_post_image);
        #console.log(output)

        # Fix the delay and setInterval.

        $wrapper = $('.posts-wrapper')
        $wrapper.fadeOut('slow').promise().done (wrapper) ->
          $('.posts').replaceWith(output)
          $wrapper.fadeIn('slow')

          #map = initialize_map()
          for layer in window.layers
            console.log(layer)
            layer.onMap = true
            @home_map.removeLayer(layer)
          map_helpers.set_home_markers(@home_map)
          # Update the map.

  template: """
    <ul class="posts no-bullet">
      {{#posts}}
      <li class="post_{{id}} post row">
        <div class="row">
          <div class="large-2 columns post-list-image">
            <a href="/posts/{{id}}">
            {{#image_web_url}}
              <img src="{{image_web_url}}" />
            {{/image_web_url}}
            {{^image_web_url}}
              <img src="{{default_post_image}}" />
            {{/image_web_url}}
            </a>
          </div>

          <div class="large-10 columns">
            <span class="post-title"><a id="post_{{id}}" href="/posts/{{id}}">{{title}}</a></span>
            <br>
            <span class="grey post-date smaller-text">
              {{created_at}} by <a class="grey-link" href="/users/{{user.id}}">{{user.username}}</a>
            </span>
          </div>
        </div>
      </li>
      {{/posts}}
    </ul>
  """

  delay: (ms, func) ->
    console.log(ms)
    @posts_refresh = setTimeout(func, ms)

  often: (ms, func) ->
    setInterval(func, ms)

