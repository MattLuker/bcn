ready_home = ->
  if $('#map').length && $('#map').is(':visible') && location.pathname == '/'
    map = initialize_map()
    map_helpers.set_home_markers(map)

    scroller.delay(30000, scroller.update_posts(2))



# Fire the ready function on load and refresh.
$(document).ready(ready_home)
$(document).on('page:load', ready_home)
