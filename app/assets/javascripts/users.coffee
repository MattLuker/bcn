# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready_user = ->
  $('#merge_link').attr('href', '/send_merge?email=' + $('#user_email').val())

  $('.leave-community').on 'click', (e) ->
    e.preventDefault()
    $form = $(e.target.form)
    swal(
      {
        title: "Are you sure you want to leave?",
        text: "Don't worry you can always re-join a Community",
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