$ ->
  $('.question-edit-form-trigger').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.question_form_wrapper').show()

  $('.question_form_wrapper .edit_question').on 'ajax:success', (data, status, xhr) ->
    $('.question-edit-form-trigger').show()
    $('.question_form_wrapper').hide()
