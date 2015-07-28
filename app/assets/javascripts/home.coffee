ready_home = ->
  if $('#map').length && $('#map').is(':visible') && location.pathname == '/'
    window.home_map = initialize_map()
    map_helpers.set_community_layers(window.home_map)
    map_helpers.get_home_post_markers(window.home_map)
    #map_helpers.set_post_markers(map)

    #scroller.delay(2500, scroller.get_page)
    #scroller.often(1000, scroller.update_posts(1))



# Fire the ready function on load and refresh.
$(document).ready(ready_home)
$(document).on('page:load', ready_home)
