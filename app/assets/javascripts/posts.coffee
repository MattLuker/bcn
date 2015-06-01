ready_post = ->
  #console.log('post...')
  $('.datepicker').fdatepicker()

  $('.toggle').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $form = $('.' + e.target.dataset.toggle)
    $form.toggle()

    # Expand text area to fit text.
    tx = $form.find('textarea')
    tx.height(tx.prop('scrollHeight'))

  $('.clockpicker').clockpicker({
    align: 'left',
    autoclose: true,
    donetext: 'OK'
  });

  $('.expand-map').on 'click', (e) ->
    toggle_map(e)
  $('.contract-map').on 'click', (e) ->
    toggle_map(e)

  # Set the Post edit form textarea height.
  $('#post_description').height($('#post_description').prop('scrollHeight'))

  # Display the image to be uploaded.
  $('.photo_upload').on 'change', (e) ->
    readURL(this);



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


readURL = (input) ->
  if (input.files && input.files[0])
    reader = new FileReader()

    reader.onload = (e) ->
      $('.image_to_upload').attr('src', e.target.result).removeClass('hidden');
      $swap = $('.swap')
      if $swap
        $swap.removeClass('hidden')

    reader.readAsDataURL(input.files[0]);



# Fire the ready function on load and refresh.
$(document).ready(ready_post)
$(document).on('page:load', ready_post)
