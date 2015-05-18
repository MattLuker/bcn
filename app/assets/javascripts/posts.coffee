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
    $('.' + e.target.dataset.toggle).toggle()


  $('.clockpicker').clockpicker({
    align: 'left',
    autoclose: true,
    donetext: 'OK'
  });



# Fire the ready function on load and refresh.
$(document).ready(ready_post)
$(document).on('page:load', ready_post)
