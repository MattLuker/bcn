# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready_user = ->
#  $('#user_email').blur ->
#    console.log('#user_email blur...')
  $('#merge_link').attr('href', '/send_merge?email=' + $('#user_email').val())



# Fire the ready function on load and refresh.
$(document).ready(ready_user)
$(document).on('page:load', ready_user)