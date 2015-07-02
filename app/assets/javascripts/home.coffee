ready_home = ->
  if $('#map').length && $('#map').is(':visible')
    map = initialize_map()

    map_helpers.marker_filter(map)
    map_helpers.new_location_popup(map, post_path)

    # Add all event pop-ups if on the home page else just add the specific post.
    if location.pathname == '/posts/new'
      console.log('New post...')
    else if location.pathname == '/home'
      post_path = 'home'
      url = "/api/communities"
    else
      post_path = 'post'
      url = "/api#{location.pathname}"

    console.log('paths:', post_path, url)
    $.ajax
      url: url
      dataType: "JSON"
      success: (data, status, jqXHR) ->
        # If Post show center map.
        if post_path == 'post' && data.locations.length > 0
          $('#map').remove()
          $('.map-container').append('<div id="map" class="post-map"></div>')
          map = initialize_map(data.locations[0].lat, data.locations[0].lon)

        # If Main page array of objects is returned else add the edit functionality.
        if Object.prototype.toString.call(data) == '[object Array]'
          window.layers = []
          for community in data
            markers = []
            for post in community.posts
              # Create markers for each post.
              #console.log(post, community.name)
              for loc in post.locations
                marker = new L.Marker([loc.lat, loc.lon], {
                  draggable: false,
                  title: data.title,
                  riseOnHover: true,
                })
                marker.bindPopup("<h3><a href='/posts/#{post.id}'>#{post.title}</a></h3><p>#{post.description}</p>")
                markers.push(marker)

            # Create a layerGroup for each Community.
            layer = L.layerGroup(markers)
            layer.community_id = "community_" + community.id
            layer.onMap = true
            layer.addTo(map);

            window.layers.push(layer)

        else
          try
            # Update existing Location/s.
            for loc in data.locations
              marker = new L.Marker([loc.lat, loc.lon], {
                draggable: true,
                title: loc.name,
                riseOnHover: true,
              })
              marker.addTo(map).bindPopup("<h5>#{loc.name}</h5><h4>#{data.title}<p>#{data.description}</p>")
              marker['loc_id'] = loc.id
              #console.log(marker)

              marker.on "dragend", (e) ->
                map_helpers.markerDrop(e, this, loc, data.id)


          catch error
            # If no location set for post allow marker to be set.
            map.on "click", (e) ->
                set_coord = e.latlng;

                marker = new L.Marker([set_coord.lat, set_coord.lng], {
                  draggable: true,
                });
                map.addLayer(marker);

                # Update Post location.
                $.ajax
                  url: '/api' + location.pathname + '/locations'
                  dataType: "JSON"
                  type: "post"
                  data: "location[lat]=#{set_coord.lat}&location[lon]=#{set_coord.lng}&location[post_id]=#{data.id}"
                  success: (data, status, jqXHR) ->
                    console.log(data)

                    marker.bindPopup("Location Set to:<br/> #{data.location.name}").openPopup();

                    # Update the location name, address, etc.
                    updated_location = """#{data.location.name} <br/> #{data.location.address}
                    #{data.location.city} #{data.location.state} #{data.location.postcode}"""
                    $("#location_" + data.location.id).html(updated_location)





# Fire the ready function on load and refresh.
$(document).ready(ready_home)
$(document).on('page:load', ready_home)
