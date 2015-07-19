ready_community = ->
  #
  # Determine the model: Community or Organization.
  #
  models = window.location.pathname.split('/')[1]
  if models == 'communities'
    model_name = 'community'
  else
    model_name = 'organization'

  # Subscribe button functionality.
  #
  # This should probalby combined with the Post subscribe functions and integrated into a generic function...
  #
  $('.' + model_name + '-subscribe').on 'click', (e) ->
    e.preventDefault()
    $this = $(this)
    data = $this.data()
    if (data.status == 'unsubscribed')
      $.post("/#{models}/#{data.modelId}/subscribers", 'user_id=' + data.currentUserId).success (json) ->
        button = """<a class="button small secondary #{model_name}-subscribe" title="Unsubscrbe"
                         data-model_id="{json.id}"
                         data-current-user-id="#{json.user_id}" data-status="subscribed" href="#">
                        <img class="ty-icon" src="/assets/tack-icon-green.svg" alt="Tack icon">
                        &nbsp;
                        Unsubscribe
                      </a>
                   """
        $this.replaceWith(button)
        Turbolinks.visit(window.location)

    else
      $.ajax({
        url: "/#{models}/#{data.modelId}/subscribers/#{data.currentUserId}",
        type: 'delete'
      }).success (json) ->
        button = """<a class="button small community-subscribe" title="Subscribe to Community"
                         data-model_id="#{json.id}"
                         data-current-user-id="#{json.user_id}" data-status="unsubscribed" href="#">
                        <img class="ty-icon" src="/assets/tack-icon.svg" alt="Tack icon">
                        &nbsp;
                        Subscribe
                      </a>
                   """
        $this.replaceWith(button)
        Turbolinks.visit(window.location)

  #
  # Determine if the Join button needs to be hidden.
  #
  try

    console.log(user_id)
    $.ajax({
      url: "/api/users/#{window.user_id}",
      type: 'get'
    }).success (user) ->
      console.log(user)
  catch
    console.log('no user')

  #
  # Form functionality.
  #
  if location.pathname == '/communities/new' || location.pathname == '/organizations/new'
    $('#' + model_name + '_color').on 'focus', (e) ->
      if $('.colpick').is(':hidden')
        $('.colpick').show()
        $('#' + model_name + '_color').css('margin-bottom', '3px')
      else
        $input = $('#' + model_name + '_color')
        $input.css('margin-bottom', '3px')

        $(this).parent().colpick({
          flat: true,
          layout: 'hex',
          submit: 1,
          onChange: (hsb, hex, rgb, el, bySetColor) ->
            $input = $($(el).children()[0])
            $input.css('border-color','#' + hex)
            $input.css('border-bottom-width', '5px')
            # Fill the text box just if the color was set using the picker, and not the colpickSetColor function.
            if (!bySetColor)
              $input.val('#' + hex)
          onSubmit: () ->
            $('.colpick').hide()
            $input.css('margin-bottom', '16px')
        })

    # Setup Markdown editor for description.
    if $('#' + model_name + '_description').length
      window.desc_editor = new Editor({
        element: document.getElementById(model_name + '_description'),
      })
      window.desc_editor.render()

    # Handle the Default Location map.
    map_helpers.form_map(model_name, '#new_' + model_name)



  #
  # Map functionality.
  #
  if ($('#map').length && $('#map').is(':visible')) && (models == 'communities' || models == 'organizations')
    map = initialize_map()
    map_helpers.set_default_markers(map, model_name, models)


# Fire the ready function on load and refresh.
$(document).ready(ready_community)
$(document).on('page:load', ready_community)