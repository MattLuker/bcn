ready_post = ->
  #
  # Form functionality.
  #
  action_name = window.location.pathname.substr(window.location.pathname.lastIndexOf('/') + 1)
  if location.pathname == '/posts/new' || action_name == 'edit'
    $('.datepicker').fdatepicker()

    $('.clockpicker').clockpicker({
      align: 'left',
      autoclose: true,
      donetext: 'OK'
    })

    map_helpers.form_map('post', '#new_post')

    #
    # Maybe figure out how to only call the /api/locations/show once some day
    #
    queryParams = $.getQueryParameters()
    if queryParams.hasOwnProperty('lat') && queryParams.hasOwnProperty('lon')
      $.get("/api/locations/show?lat=#{queryParams['lat']}&lon=#{queryParams['lon']}").success (data) ->
        $('#Location_Name').val(data.location.name)
        $('.location-button').click()



    # Set the Post edit form textarea height.
    $('#post_description').height($('#post_description').prop('scrollHeight'))

    # Display the image to be uploaded.
    $('.photo_upload').on 'change', (e) ->
      readURL(this);

    $('#photos').on 'change', (e) ->
      multiPhotoDisplay(this);

    # Get the Open Graph data for the Link?
    $('#post-link').on 'blur', (e) ->
      if (url != '' || url != undefined)
        $('#link-meter').removeClass('hidden')
        $(".meter").animate({width:"100%"});

        url = $('#post-link').val()
        $.get('/posts/get_og_data?url=' + url).success (data) ->
          console.log(data)
          if $.isEmptyObject(data)
            data['og_url'] = url
            data['og_image'] = image_path('link-icon.svg')

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
    #query = window.location.search.substring(1)
    queryParams = $.getQueryParameters()
    if (queryParams.hasOwnProperty('community'))
      vars = query.split("&");
      community = vars[0].split('=')[1]
      community = community.replace('+', ' ')
      $('#post_community_names').val(community)

    if (queryParams.hasOwnProperty('organization'))
      $('#post_organization_id').val(queryParams.organization)

    # Setup multi-select goodness with Chosen.
    $('.chosen-select').chosen
      allow_single_deselect: true
      no_results_text: 'No results matched'


    # Setup Markdown editor for description.
    if $('#post_description').length
      window.post_editor = new Editor({
        element: document.getElementById('post_description'),
      })
      window.post_editor.render()

  #
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

# #
# # Auto-save form functionality... maybe.
# #
#  if $('#new_post').length
#    $('#new_post').sisyphus({
#      onRelase: ->
#        localStorage['new_postundefinedpost[lon]'] = ''
#        localStorage['new_postundefinedpost[lat]'] = ''
#    })

  #
  # Show page functionality.
  #
  if $('#map').length && $('#map').is(':visible') && location.pathname.split('/')[1] == 'posts'
    map = initialize_map()
    map_helpers.set_post_markers(map, 'post-map')

    $('.expand-map').on 'click', (e) ->
      toggle_map(e)
    $('.contract-map').on 'click', (e) ->
      toggle_map(e)

  # Handle hidden elements and the buttons that reveal them.
  $('.toggle').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $form = $('.' + e.target.dataset.toggle)
    $form.toggle()


toggle_map = (e) ->
  #
  # Make the map big, or small.
  #
  e.preventDefault()
  $map_container = $('.map-container')
  $map = $('#map')

  if ($map_container.hasClass('large-3'))
    $('.map-container').removeClass('large-3').addClass('large-12')
    height = '550px'
    $('.expand-map').addClass('hidden')
    $('.contract-map').removeClass('hidden')
    $map.removeClass('post-map-large')
    $map.addClass('post-map')
    map_class = 'post-map-large'
  else
    $('.map-container').removeClass('large-12').addClass('large-3')
    height = '300px'
    $('.expand-map').removeClass('hidden')
    $('.contract-map').addClass('hidden')
    map_class = 'post-map'

  $map.remove()
  $map_container.append('<div id="map" class="post-map-large"></div>')
  $map.css('height', height)

  map = initialize_map()
  #map_helpers.set_markers(map, 'post-map-large')
  map_helpers.set_post_markers(map, map_class)


@readURL = (input) ->
  #
  # Read the contents of the image file to be uploaded and display it.
  #
  if (input.files && input.files[0])
    reader = new FileReader()

    reader.onload = (e) ->
      $('.image_to_upload').attr('src', e.target.result).removeClass('hidden');
      $swap = $('.swap')
      if $swap
        $swap.removeClass('hidden')

    reader.readAsDataURL(input.files[0]);


@multiPhotoDisplay = (input) ->
  #
  # Read the contents of the image file to be uploaded and display it.
  #
  if (input.files && input.files[0])
    for file in input.files
      reader = new FileReader()

      reader.onload = (e) ->
        console.log('e:', e)
        image_html = """<li><a class="th" href="#{e.target.result}"><img width="75" src="#{e.target.result}"></a></li>"""

        $('#photos_clearing').append(image_html)

        if $('.pics-label.hide').length != 0
          $('.pics-label').toggle('hide').removeClass('hide')

        $(document).foundation('reflow')

      reader.readAsDataURL(file);


# Fire the ready function on load and refresh.
$(document).ready(ready_post)
$(document).on('page:load', ready_post)
