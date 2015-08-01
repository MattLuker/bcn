ready_home = ->
  if $('#map').length && $('#map').is(':visible') && location.pathname == '/'
    window.home_map = initialize_map()
    map_helpers.set_community_layers(window.home_map)
    map_helpers.get_home_post_markers(window.home_map)
    #map_helpers.button_binder()
    #map_helpers.set_post_markers(map)

    #scroller.delay(2500, scroller.get_page)
    scroller.often(7000, scroller.get_page)

    $(document).on 'click', (e) ->
      clearInterval(window.refresher);


# Fire the ready function on load and refresh.
$(document).ready(ready_home)
$(document).on('page:load', ready_home)
