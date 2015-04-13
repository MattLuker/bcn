# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#$(document).ready ->
ready = ->
  # Initialize the Open Street Map map.
  map = new L.Map('map');

  # Create the tile layer with correct attribution.
  osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
  osm = new L.TileLayer(osmUrl, {minZoom: 6, maxZoom: 19, attribution: osmAttrib});   

  # Start the map over Boone, Appalachina Street to be exact.
  map.setView(new L.LatLng(36.2168253, -81.6824657), 15);
  map.addLayer(osm);

  # Add all event pop-ups if on the home page else just add the specific post.
  if location.pathname == '/home'
    url = "/api/communities"
  else
    url = "/api#{location.pathname}"

  $.ajax
    url: url
    dataType: "JSON"
    success: (data, status, jqXHR) ->
      #console.log(data)
      
      # If Main page array of objects is returned else add the edit functionality.
      if Object.prototype.toString.call(data) == '[object Array]' 
        window.layers = []
        for community in data
          #L.marker([post.location.lat, post.location.lon], {draggable:false}).addTo(map)
          #  .bindPopup("<h3>#{post.title}</h3><p>#{post.description}</p>");
          markers = []
          for post in community.posts
            # Create markers for each post.
            #console.log(post, community.name)
            marker = new L.Marker([post.location.lat, post.location.lon], {
              draggable: false,
              title: data.title,
              riseOnHover: true,
            })
            marker.bindPopup("<h3>#{post.title}</h3><p>#{post.description}</p>")
            markers.push(marker)

          # Create a layerGroup for each Community.
          layer = L.layerGroup(markers)
          layer.community_id = "community_" + community.id
          layer.onMap = true
          layer.addTo(map);

          window.layers.push(layer)

          #comLayer = L.layerGroup(markers)
          #overlayMaps[community] = comLayer

        #L.control.layers(overlayMaps).addTo(map);
      else
        try
          # Turn off the new marker on click.
          map.off "click"

          # Set the marker.
          marker = new L.Marker([data.location.lat, data.location.lon], {
            draggable: true,
            title: data.title,
            riseOnHover: true,
          })
          marker.addTo(map).bindPopup("<h3>#{data.title}</h3><p>#{data.description}</p>")

          marker.on "dragend", (e) ->
            drop_coord = e.target._latlng
            console.log(drop_coord)
            #
            # Send an $.ajax request to update the location.
            #
            # Maybe break this out into it's own updateLocation() function, or something...
            $.ajax
              url: '/api' + location.pathname + '/locations/' + data.location.id
              dataType: "JSON"
              type: "patch"
              data: "location[lat]=#{drop_coord.lat}&location[lon]=#{drop_coord.lng}&location[post_id]=#{data.id}"
              success: (updated_data, status, jqXHR) ->
                console.log(updated_data)
                
                # Flash a message either on the marker.
                marker.bindPopup("Location updated to:<br/> #{updated_data.location.name}").openPopup();

                # Update the location name, address, etc.
                updated_location = """#{updated_data.location.name} <br/> #{updated_data.location.address}
                  #{updated_data.location.city} #{updated_data.location.state} #{updated_data.location.postcodee}"""
                $("#post_" + updated_data.post.id).html(updated_location)
                
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
                  #console.log(data)
              
                  marker.bindPopup("Location Set to:<br/> #{data.location.name}").openPopup();

                  # Update the location name, address, etc.
                  updated_location = """#{data.location.name} <br/> #{data.location.address}
                  #{data.location.city} #{data.location.state} #{data.location.postcode}"""
                  $("#post_" + data.post.id).html(updated_location)
   
    
  # Bind clicks to new marker on the main map, if marker is already there update it.
  marker = undefined
  map.on "click", (e) ->
      coord = e.latlng;

      markerHtml = "<br/><a id='new_post' href='/posts/new?lat=#{coord.lat}&lon=#{coord.lng}'>New Post</a>"

      if (typeof(marker) == 'undefined') 
        marker = new L.Marker(e.latlng);
        map.addLayer(marker);
      else 
        marker.setLatLng(e.latlng);         
      
      marker.bindPopup(markerHtml).openPopup()


  # Remove all markers not in button's community.
  $('.community').on "click", (e) ->
    #console.log("target.id:", e.target.id)
    #console.log(map._layers)
    #console.log("window.layers:", window.layers)

    toggleLayers = $.grep window.layers, (layer) ->
      #console.log('community_id:', community_id)
      #console.log(layer.community_id)
      return layer.community_id != e.target.id;

    #console.log("toggleLayers:", toggleLayers)

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


# Fire the ready function on load and refresh.
$(document).ready(ready)
$(document).on('page:load', ready)
