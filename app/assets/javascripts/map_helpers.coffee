@map_helpers =
  marker_filter: (map) ->
    # Remove all markers not in button's community.
      $('.community').on "click", (e) ->

        toggleLayers = $.grep window.layers, (layer) ->
          return layer.community_id != e.target.id;

        for layer in window.layers
          layer.onMap = true
          map.addLayer(layer)

        for layer in toggleLayers
          if (layer.onMap)
            layer.onMap = false
            map.removeLayer(layer)
          else
            layer.onMap = true
            map.addLayer(layer)

      # Change the button color when selected.

      # Add all markers to the map.
      $('.all_communities').on "click", (e) ->
        for layer in window.layers
          layer.onMap = true
          map.addLayer(layer)


  markerDrop: (e, marker, loc, post_id) ->
    drop_coord = e.target._latlng
    console.log("latlng:", e.target._latlng)

    # Send an $.ajax request to update the location.
    $.ajax
      url: '/api' + location.pathname + '/locations/' + marker.loc_id
      dataType: "JSON"
      type: "patch"
      data: "location[lat]=#{drop_coord.lat}&location[lon]=#{drop_coord.lng}&location[post_id]=#{post_id}"
      success: (updated_data, status, jqXHR) ->
        #console.log(updated_data)

        # Flash a message either on the marker.
        marker.bindPopup("Location updated to:<br/> #{updated_data.location.name}").openPopup();

        # Update the location name, address, etc.
        updated_location = """#{updated_data.location.name} <br/> #{updated_data.location.address}
                    #{updated_data.location.city} #{updated_data.location.state} #{updated_data.location.postcodee}"""
        $("#location_" + marker.loc_id).html(updated_location)

      error: (data, status, jqXHR) ->
        #console.log(data)
        response = JSON.parse(data.responseText)
        marker.bindPopup("<span class='alert'>#{response.message}</span>").openPopup();


  postMarkerDrop: (e, marker, loc_input) ->
    drop_coord = e.target._latlng
    console.log("latlng:", e.target._latlng)

    # Send an $.ajax request to update the location.
    $.ajax
      url: '/api/locations/show?lat=' + drop_coord.lat + '&lon=' + drop_coord.lng
      dataType: "JSON"
      success: (updated_data, status, jqXHR) ->
        console.log(updated_data)

        # Flash a message either on the marker.
        marker.bindPopup("Location updated to:<br/> #{updated_data.location.name}").openPopup();

        # Update the location name, address, etc.
        updated_location = """#{updated_data.location.name} <br/> #{updated_data.location.address}
                    #{updated_data.location.city} #{updated_data.location.state} #{updated_data.location.postcodee}"""
        loc_input.val(updated_data.location.name)

        $('#post_lat').remove()
        $('#post_lon').remove()
        $('#new_post').append("<input value='#{drop_coord.lat}' type='hidden' name='post[lat]' id='post_lat'>
           <input value='#{drop_coord.lng}' type='hidden' name='post[lon]' id='post_lon'>")

      error: (data, status, jqXHR) ->
        #console.log(data)
        response = JSON.parse(data.responseText)
        marker.bindPopup("<span class='alert'>#{response.message}</span>").openPopup();


  new_location_popup: (map, path) ->
    # Bind clicks to new marker on the main map, if marker is already there update it.
    marker = undefined
    map.on "click", (e) ->
      coord = e.latlng;
      window.coord = coord

      if path == 'home'
        markerHtml = """<br/>
                          <a id='new_post' href='/posts/new?lat=#{coord.lat}&lon=#{coord.lng}'>New Post</a>
                          <br/><br/>
                          <a id='posts_here' href='/locations?lat=#{coord.lat}&lon=#{coord.lng}'>
                            What's Happening Here
                          </a>
                          <br/>
                       """
      else
        markerHtml = "<br/><a id='new_location' href='#'>Add Location</a>"

      if (typeof(marker) == 'undefined')
        marker = new L.Marker(e.latlng, { icon: divDefaultIcon });
        map.addLayer(marker);
      else
        marker.setLatLng(e.latlng)

      marker.bindPopup(markerHtml).openPopup()

    map.on 'popupopen', (e) ->
      $('#new_location').on 'click', (e) ->
        e.preventDefault()
        #console.log('new_location clicked...')
        #      console.log(window.coord)
        $.ajax
          url: "/api#{location.pathname}/locations"
          dataType: "JSON"
          type: "post"
          data: "location[lat]=#{coord.lat}&location[lon]=#{coord.lng}"
          success: (data, status, jqXHR) ->
            #console.log(jqXHR.responseText)

            # Update the popup.
            data.locations.sort()
            new_loc = data.locations[data.locations.length-1]
            marker.bindPopup("Location Set to:<br/> #{new_loc.name}").openPopup();

            # Update the Locations <ul>.
            new_loc_html = """<li>
                              <span id="location_#{new_loc.id}">
                              <strong>#{new_loc.name}</strong>
                              <br/>
                              #{new_loc.address}
                              #{new_loc.city} #{new_loc.state} #{new_loc.postcode}
                              </span>
                              <a class="button alert tiny remove_location icon"
                                  title="Remove Location"
                                  data-sweet-alert-confirm="Are you sure?"
                                  rel="nofollow" data-method="delete"
                                  href="/posts/#{data.post.id}/locations/#{new_loc.id}">
                                <img class="icon" src="/assets/trash-icon.svg" alt="Trash icon">
                              </a>
                              </li>
                           """
            if ($('#post_' + data.post.id).length)
              $('#post_' + data.post.id).append(new_loc_html)
            else
              $('#no-locations').replaceWith(new_loc_html)
              Turbolinks.visit(window.location)
          error: (data, status, jqXHR) ->
            #console.log(data)
            response = JSON.parse(data.responseText)
            marker.bindPopup("<span class='alert'>#{response.message}</span>").openPopup();


  set_markers: (map, map_class = 'post-map') ->
    # Add all event pop-ups if on the home page else just add the specific post.
    if location.pathname == '/posts/new'
      console.log('New post...')
    else if location.pathname == '/home'
      post_path = 'home'
      url = "/api/communities"
    else
      post_path = 'post'
      url = "/api#{location.pathname}"

    map_helpers.marker_filter(map)
    map_helpers.new_location_popup(map, post_path)

    $.ajax
      url: url
      dataType: "JSON"
      success: (data, status, jqXHR) ->

        # If Post show center map.
        if post_path == 'post' && data.locations.length > 0
          $('#map').remove()
          $('.map-container').append("<div id='map' class='#{map_class}'></div>")
          map = initialize_map(data.locations[0].lat, data.locations[0].lon)
          map_helpers.marker_filter(map)
          map_helpers.new_location_popup(map, post_path)

        # If Main page array of objects is returned else add the edit functionality.
        if Object.prototype.toString.call(data) == '[object Array]'
          window.layers = []
          for community in data
            markers = []
            for post in community.posts
              # Create markers for each post.
              #console.log(post, community.name)
              for loc in post.locations

                divCommunityIcon = L.divIcon({
                  className: 'marker-div-icon',
                  html: get_svg(community.color, 50, 50),
                  popupAnchor: [8, -3],
                });

                marker = new L.Marker([loc.lat, loc.lon], {
                  draggable: false,
                  title: data.title,
                  riseOnHover: true,
                  icon: divCommunityIcon
                })
                marker.bindPopup("""
                <h3><a href='/posts/#{post.id}'>#{post.title}</a></h3>
                <p>#{marked(post.description)}</p>
                <a href='/posts/#{post.id}/edit' class='button tiny icon'>
                  <img src='#{window.image_path('edit-icon.svg')}' class='ty-icon'/>
                </a>
                """)
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
                icon: divDefaultIcon
              })
              marker.addTo(map).bindPopup("<h5>#{loc.name}</h5><h4>#{data.title}<p>#{marked(data.description)}</p>")
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
                icon: divDefaultIcon
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






@initialize_map = (lat = 36.2168253, lon = -81.6824657, zoom = 15) ->
  # Initialize the Open Street Map map.
  map = new L.Map('map');

  # Create the tile layer with correct attribution.
  osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
  osm = new L.TileLayer(osmUrl, {minZoom: 6, maxZoom: 19, attribution: osmAttrib});

  # Start the map over Boone, Appalachina Street to be exact.
  map.setView(new L.LatLng(lat, lon), zoom);
  map.addLayer(osm);

  # Add all event pop-ups if on the home page else just add the specific post.
  if location.pathname == '/home'
    post_path = 'home'
    url = "/api/communities"
  else
    post_path = 'post'
    url = "/api#{location.pathname}"


  @divDefaultIcon = L.divIcon({
    className: 'marker-div-icon',
    html: get_svg('#008CBA', 30, 55),
    popupAnchor: [-9, -53],
    iconAnchor: [20, 55],
  });

  return map
