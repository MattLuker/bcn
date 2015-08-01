#
# Replace Recent Posts on the home page with the next 5 after 30 seconds.
#
@scroller =
  get_page: () ->
    if not window.page_number? || window.page_number == 0
      window.page_number = 1
    else
      window.page_number += 1

    $.ajax
      url: '/api/posts?page=' + window.page_number
      success: (posts, status, jqXHR) ->
        if posts.length == 0
          window.page_number = 0
          scroller.get_page()
        else
          scroller.update_posts(posts, window.page_number)


  update_posts: (posts, page=1) ->
    # Put the array into an object for the Mustache template.
    posts = {posts, default_post_image: default_post_image}
    output = Mustache.render(scroller.template, posts, default_post_image);

    $wrapper = $('.posts-wrapper')
    $wrapper.fadeOut('slow').promise().done (wrapper) ->
      $('.posts').replaceWith(output)

      # Remove old markers.
      for layer in window.layers
        layer.onMap = false
        window.home_map.removeLayer(layer)
        layer.clearLayers()

      # Update the map.
      if page > 0
        map_helpers.get_home_post_markers(window.home_map, page)
      else
        map_helpers.set_home_post_markers(posts.posts)


      $wrapper.fadeIn('slow')

      # Update the Community buttons.
      communities = []
      for post in posts.posts
        communities = communities.concat(post.communities)

      # Remove duplicate Communities.
      communities = (value for _,value of communities.reduce ((arr,value) -> arr[value.id] = value; arr),{})
      scroller.set_map_communities(communities)


  set_map_communities: (communities) ->
    $communities_wrapper = $('.communities-wrapper')
    $communities_wrapper.html('')

    for community in communities
      $communities_wrapper.append("""
        <button class="community tiny" id="community_#{community.id}">
          #{community.name}
        </button>&nbsp;
      """)

    map_helpers.marker_filter(window.map, 'community', 'communities')


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
              {{start_date}} by <a class="grey-link" href="/users/{{user.id}}">{{user.username}}</a>
            </span>
          </div>
        </div>
      </li>
      {{/posts}}
    </ul>
  """

  delay: (ms, func) ->
    @posts_refresh = setTimeout(func, ms)

  often: (ms, func) ->
    window.refresher = setInterval(func, ms)