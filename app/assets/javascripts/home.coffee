ready_home = ->
  if $('#map').length && $('#map').is(':visible') && location.pathname == '/'
    map = initialize_map()
    map_helpers.set_home_markers(map)


# Fire the ready function on load and refresh.
$(document).ready(ready_home)
$(document).on('page:load', ready_home)
