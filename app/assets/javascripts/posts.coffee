ready_post = ->
  $('.datepicker').fdatepicker()

  $('.toggle').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $form = $('.' + e.target.dataset.toggle)
    $form.toggle()


  $('.clockpicker').clockpicker({
    align: 'left',
    autoclose: true,
    donetext: 'OK'
  });

  $('.expand-map').on 'click', (e) ->
    toggle_map(e)
  $('.contract-map').on 'click', (e) ->
    toggle_map(e)


  map_helpers.form_map('post', '#new_post')

  # Set the Post edit form textarea height.
  $('#post_description').height($('#post_description').prop('scrollHeight'))

  # Display the image to be uploaded.
  $('.photo_upload').on 'change', (e) ->
    readURL(this);

  # Subscribe button functionality.
  #
  # Not sure the button needs to be replaced since Turbolinks is refreshing the page, but maybge it'll be useful down
  # the road...
  #
  $('.post-subscribe').on 'click', (e) ->
    e.preventDefault()
    #console.log($(this).data())
    $this = $(this)
    data = $this.data()
    if (data.status == 'unsubscribed')
      $.post("/posts/#{data.postId}/subscribers", 'user_id=' + data.currentUserId).success (json) ->
        button = """<a class="button tiny secondary icon post-subscribe" title="Unsubscrbie from Post"
                       data-post-id="#{json.post_id}"
                       data-current-user-id="#{json.user_id}" data-status="unsubscribed" href="#">
                      <img class="icon" src="/assets/tack-icon-green.svg" alt="Unsubscribe", title="Unsubscribe">
                    </a>
                 """
        $this.replaceWith(button)
        Turbolinks.visit(window.location)

    else
      $.ajax({
        url: "/posts/#{data.postId}/subscribers/#{data.currentUserId}",
        type: 'delete'
      }).success (json) ->
        button = """<a class="button tiny icon post-subscribe" title="Subscribe to Post" data-post-id="#{json.post_id}"
                       data-current-user-id="#{json.user_id}" data-status="unsubscribed" href="#">
                      <img class="icon" src="/assets/tack-icon.svg" alt="Subscribe", title="Subscribe">
                    </a>
                 """
        $this.replaceWith(button)
        Turbolinks.visit(window.location)

  # Get the Open Graph data for the Link?
  $('#post-link').on 'blur', (e) ->
    if (url != '' || url != undefined)
      $('#link-meter').removeClass('hidden')
      $(".meter").animate({width:"100%"});

      url = $('#post-link').val()
      $.get('/posts/get_og_data?url=' + url).success (data) ->
        #console.log(data)
        $error = $('.og-error')
        if $error.is(':visible')
          $error.toggle()

        $('.og-url').attr('href', data.og_url)

        $('.og-image').attr('src', data.og_image)
        $('.og-title').text(data.og_title)
        $('.og-description').text(data.og_description)
        if (data.og_error != undefined)
          $error.text(data.og_error).toggle()
        $('.og-data').removeClass('hidden')

        $('#post_og_url').val(data.og_url)
        $('#post_og_image').val(data.og_image)
        $('#post_og_title').val(data.og_title)
        $('#post_og_description').val(data.og_description)


  # Start Communities field with community parameter.
  query = window.location.search.substring(1)
  if (query && query.includes('community'))
    vars = query.split("&");
    community = vars[0].split('=')[1]
    community = community.replace('+', ' ')
    $('#post_community_names').val(community)

  # Setup multi-select goodness with Chosen.
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'


  # Setup Markdown editor for description.
  if $('#post_description').length
    post_editor = new Editor({
      element: document.getElementById('post_description'),
    })
    post_editor.render()

#  if $('#new_post').length
#    $('#new_post').sisyphus({
#      onRelase: ->
#        localStorage['new_postundefinedpost[lon]'] = ''
#        localStorage['new_postundefinedpost[lat]'] = ''
#    })


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
  $map_container.append('<div id="map" class="post-map-large"></div>')
  $('#map').css('height', height)

  map = initialize_map()
  map_helpers.set_markers(map, 'post-map-large')


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
