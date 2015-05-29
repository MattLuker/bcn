# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#getParams = ->
#  query = window.location.search.substring(1)
#  raw_vars = query.split("&")
#
#  params = {}
#
#  for v in raw_vars
#    [key, val] = v.split("=")
#    params[key] = decodeURIComponent(val)
#
#  params
#
#

ready_post = ->
  #console.log('post...')
  $('.datepicker').fdatepicker()

  $('.toggle').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('.' + e.target.dataset.toggle).toggle()


  $('.clockpicker').clockpicker({
    align: 'left',
    autoclose: true,
    donetext: 'OK'
  });

  $('.expand-map').on 'click', (e) ->
    e.preventDefault()
    $('.map-container').removeClass('large-3').addClass('large-12')
    $('#map').remove()
    $('.map-container').append('<div id="map" class="post-map"></div>')
    $('#map').css('height', '550px')
    #window.initialize_map()
    window.ready_home()
    $('.expand-map').hide()


# Fire the ready function on load and refresh.
$(document).ready(ready_post)
$(document).on('page:load', ready_post)
