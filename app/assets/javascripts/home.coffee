ready_home = ->
  if $('#map').length && $('#map').is(':visible')
    map = initialize_map()
    map_helpers.set_markers(map)


# Fire the ready function on load and refresh.
$(document).ready(ready_home)
$(document).on('page:load', ready_home)
