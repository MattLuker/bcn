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


  update_posts: (posts, page=1, community=false, events=false) ->
    # Put the array into an object for the Mustache template.
    posts = {posts, default_post_image: default_post_image}
    if events?
      events = {events, default_post_image: default_event_image}

    # Update the Communities and created_at strings.
    communities = []
    for post in posts.posts
      communities = communities.concat(post.communities)
      if post.start_date?
        post.start_date = moment(post.start_date).format('M/D/YYYY')
        #post.image_web_url = default_event_image
      if post.start_time?
        post.start_time = moment(post.start_time).format('h:mm a')
      post.created_at = moment(post.created_at).fromNow()

    posts_output = Mustache.render(scroller.posts_template, posts, default_post_image);
    events_output = Mustache.render(scroller.events_template, events, default_event_image);

    $posts_wrapper = $('.posts-wrapper')
    $events_wrapper = $('.events-wrapper')
    $posts_wrapper.fadeOut('slow').promise().done (wrapper) ->
      $('.posts').replaceWith(posts_output)
      $('.events').replaceWith(events_output)

      # Remove old markers.
      for layer in window.layers
        layer.onMap = false
        window.home_map.removeLayer(layer)
        layer.clearLayers()

      # Update the map.
      if page > 0
        map_helpers.get_home_post_markers(window.home_map, page)
      else
        if community != false
          map_helpers.set_home_post_markers(posts.posts, community)
        else
          map_helpers.set_home_post_markers(posts.posts)


      $posts_wrapper.fadeIn('slow')


  set_map_communities: (communities) ->
    $communities_wrapper = $('.communities-wrapper')
    $communities_wrapper.html('')

    for community in communities
      $communities_wrapper.append("""
        <button class="community tiny" data-id="#{community.id} id="community_#{community.id}">
          #{community.name}
        </button>&nbsp;
      """)

    map_helpers.marker_filter(window.map, 'community', 'communities')


  posts_template: """
    <ul class="posts no-bullet">
      {{#posts}}
      <li class="post_{{id}} post row">
        <div class="row">
          <div class="small-4 large-2 columns post-list-image">
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
              {{#start_date}}
                On: {{start_date}} @ {{start_time}}
              {{/start_date}}
              {{^start_date}}
                {{created_at}}
              {{/start_date}}
              {{#organization}}
                by <a class="grey-link" href="/organizations/{{organization.slug}}">{{organization.name}}</a>
              {{/organization}}
              {{^organization}}
                by <a class="grey-link" href="/users/{{user.id}}">{{user.username}}</a>
               {{/organization}}
            </span>
          </div>
        </div>
      </li>
      {{/posts}}
    </ul>
  """

  events_template: """
    <ul class="events no-bullet">
      {{#events}}
      <li class="post_{{id}} post row">
        <div class="row">
          <div class="small-4 large-2 columns post-list-image">
            <a href="/posts/{{id}}">
            {{#image_web_url}}
              <img src="{{image_web_url}}" />
            {{/image_web_url}}
            {{^image_web_url}}
              <img src="{{default_event_image}}" />
            {{/image_web_url}}
            </a>
          </div>

          <div class="large-10 columns">
            <span class="post-title"><a id="post_{{id}}" href="/posts/{{id}}">{{title}}</a></span>
            <br>
            <span class="grey post-date smaller-text">
              {{#start_date}}
                On: {{start_date}} @ {{start_time}}
              {{/start_date}}
              {{^start_date}}
                {{created_at}}
              {{/start_date}}
              {{#organization}}
                by <a class="grey-link" href="/organizations/{{organization.slug}}">{{organization.name}}</a>
              {{/organization}}
              {{^organization}}
                by <a class="grey-link" href="/users/{{user.id}}">{{user.username}}</a>
               {{/organization}}
            </span>
          </div>
        </div>
      </li>
      {{/events}}
    </ul>
  """

  delay: (ms, func) ->
    @posts_refresh = setTimeout(func, ms)

  often: (ms, func) ->
    window.refresher = setInterval(func, ms)