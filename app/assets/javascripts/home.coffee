ready_home = ->
  if $('#map').length && $('#map').is(':visible') && (location.pathname == '/' || location.pathname == '/home')
    window.home_map = initialize_map()
    map_helpers.set_community_layers(window.home_map)
    map_helpers.get_home_post_markers(window.home_map)
    window.layers = []
    #map_helpers.button_binder()
    #map_helpers.set_post_markers(map)
    #scroller.get_page()

    #scroller.delay(2500, scroller.get_page)
    #scroller.often(7000, scroller.get_page)

    $(document).on 'click', (e) ->
      clearInterval(window.refresher);

    # Clamp (truncate) the Post description in the marker popups.
    window.map.on 'popupopen', (e) ->
      $('.c').truncateLines({lines: 4})

      # Nothing really needed to do... no second paragraph in popup.



# Fire the ready function on load and refresh.
$(document).ready(ready_home)
$(document).on('page:load', ready_home)
