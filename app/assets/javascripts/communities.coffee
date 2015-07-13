ready_community = ->
  # Subscribe button functionality.
  #
  # This should probalby combined with the Post subscribe functions and integrated into a generic function...
  #
  $('.community-subscribe').on 'click', (e) ->
    e.preventDefault()
    #console.log($(this).data())
    $this = $(this)
    data = $this.data()
    if (data.status == 'unsubscribed')
      $.post("/communities/#{data.communityId}/subscribers", 'user_id=' + data.currentUserId).success (json) ->
        button = """<a class="button small secondary community-subscribe" title="Unsubscrbe from Community"
                         data-community-id="#{json.community_id}"
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
        url: "/communities/#{data.communityId}/subscribers/#{data.currentUserId}",
        type: 'delete'
      }).success (json) ->
        button = """<a class="button small community-subscribe" title="Subscribe to Community" data-community-id="#{json.community_id}"
                         data-current-user-id="#{json.user_id}" data-status="unsubscribed" href="#">
                        <img class="ty-icon" src="/assets/tack-icon.svg" alt="Tack icon">
                        &nbsp;
                        Subscribe
                      </a>
                   """
        $this.replaceWith(button)
        Turbolinks.visit(window.location)


  #
  # Form functionality.
  #
  if location.pathname == '/communities/new'
    $('#community_color').on 'focus', (e) ->

      if $('.colpick').is(':hidden')
        $('.colpick').show()
        $('#community_color').css('margin-bottom', '3px')
      else
        $input = $('#community_color')
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
    if $('#community_description').length
      window.desc_editor = new Editor({
        element: document.getElementById('community_description'),
      })
      window.desc_editor.render()

    # Handle the Default Location map.
    map_helpers.form_map('community', '#new_community')


  #
  # Map functionality.
  #
  if $('#map').length && $('#map').is(':visible') && location.pathname.split('/')[1] == 'communities'
    map = initialize_map()
    map_helpers.set_community_markers(map)


# Fire the ready function on load and refresh.
$(document).ready(ready_community)
$(document).on('page:load', ready_community)