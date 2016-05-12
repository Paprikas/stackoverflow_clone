$ ->
  $(document).on 'click', '.email-confirmation-form-trigger', (e) ->
    e.preventDefault()
    $('.email-confirmation-form').toggle()
