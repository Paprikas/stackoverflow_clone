$ ->
  $(document).on 'ajax:success', '.notify', (data, status, xhr) ->
    buttons_wrapper = $(this).closest('.notification_buttons')
    if xhr == 'nocontent'
      buttons_wrapper.removeClass('notified')
    else
      buttons_wrapper.addClass('notified')
