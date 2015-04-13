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
#$(document).ready ->
#  coord = getParams()
#  $('#new_post').append("<input type='hidden' name='lat' value='#{coord.lat}'/>")
#  $('#new_post').append("<input type='hidden' name='lon' value='#{coord.lon}'/>")
#  console.log($('#new_post'));
