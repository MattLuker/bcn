ready_user = ->
  #
  # Form functionality.
  #
  $('#merge_link').attr('href', '/send_merge?email=' + $('#user_email').val())

  # Setup Markdown editor for description.
  if $('#user_bio').length
    window.bio_editor = new Editor({
      element: document.getElementById('user_bio'),
    })
    window.bio_editor.render()

  $('.notification').on 'click', (e) ->
    $input = $(this)
    $input.attr('checked', 'true')


  #
  # Leave Community button functionality.
  #
  $('.leave-community, .leave-organization').on 'click', (e) ->
    e.preventDefault()
    leave(e)

leave = (event) ->
  $form = $(event.target.form)
  console.log($form.attr('class').split('-')[1])

  model_name = $form.attr('class').split('-')[1]

  swal(
    {
      title: "Are you sure you want to leave?",
      text: "Don't worry you can always re-join a #{model_name}.",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#F04124",
      confirmButtonText: "Yes, Leave!",
      closeOnConfirm: true
    }
    (isConfirm) ->
      if (isConfirm)
        $form.submit()
  );

# Fire the ready function on load and refresh.
$(document).ready(ready_user)
$(document).on('page:load', ready_user)