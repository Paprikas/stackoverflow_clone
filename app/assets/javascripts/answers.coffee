$ ->
  $(document).on 'click', '.answer-edit-form-trigger', (e) ->
    e.preventDefault()
    $(this).hide()
    $('.answer_form_wrapper').show()

  $(document).on 'ajax:success', 'answer_form_wrapper .edit_answer', (data, status, xhr) ->
    $('.answer-edit-form-trigger').show()
    $('.answer_form_wrapper').hide()
