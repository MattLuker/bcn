ready_searches = ->
  # Handle the Enter key.
  $('#search_query').on 'keyup', (e) ->
    if (e.which == 13)
      Turbolinks.visit('/searches?query=' + $('#search_query').val())

  # Handle the Search button.
  $('#search_button').on 'click', (e) ->
    e.preventDefault()
    $.get('/searches?query=' + $('#search_query').val())
    Turbolinks.visit('/searches?query=' + $('#search_query').val())


# Fire the ready function on load and refresh.
$(document).ready(ready_searches)
$(document).on('page:load', ready_searches)