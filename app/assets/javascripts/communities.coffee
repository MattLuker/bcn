ready_community = ->
  console.log('community ready...')
  # Subscribe button functionality.
  #
  # This should probalby combined with the Post subscribe functions and integrated into a generic function...
  #
  $('.community-subscribe').on 'click', (e) ->
    e.preventDefault()
    console.log($(this).data())
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
  console.log('community ready... end.')


# Fire the ready function on load and refresh.
$(document).ready(ready_community)
$(document).on('page:load', ready_community)