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
    toggle_map(e)
  $('.contract-map').on 'click', (e) ->
    toggle_map(e)


toggle_map = (e) ->
  e.preventDefault()
  $map_container = $('.map-container')

  if ($map_container.hasClass('large-3'))
    $('.map-container').removeClass('large-3').addClass('large-12')
    height = '550px'
    $('.expand-map').addClass('hidden')
    $('.contract-map').removeClass('hidden')
  else
    $('.map-container').removeClass('large-12').addClass('large-3')
    height = '300px'
    $('.expand-map').removeClass('hidden')
    $('.contract-map').addClass('hidden')


  $('#map').remove()
  $map_container.append('<div id="map" class="post-map"></div>')

  $('#map').css('height', height)
  window.ready_home()

# Fire the ready function on load and refresh.
$(document).ready(ready_post)
$(document).on('page:load', ready_post)
