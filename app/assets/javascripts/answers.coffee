$ ->
  $(document).on 'click', '.answer-edit-form-trigger', (e) ->
    e.preventDefault()
    $(this).hide()
    $('.answer_form_wrapper').show()

  $(document).on 'ajax:success', '.new_answer, .edit_answer',
  (e, data, status, xhr) ->
    form_wrapper = $(this).closest('.answer_form_wrapper')
    form_wrapper.find('.answer_errors').text('')

    if $(this).hasClass('edit_answer')
      form_wrapper.hide()
      answer = $(this).closest('.answer')
      answer.find('.answer-edit-form-trigger').show()
      answer.find('.body').html(xhr.responseJSON.answer)
    else
      form_wrapper.find('textarea').val('')

  .on 'ajax:error', '.new_answer, .edit_answer', (e, xhr) ->
    errors = ''
    for error in xhr.responseJSON.errors
      do (error) ->
        errors += '<p>' + error + '</p>'
    $(this).closest('.answer_form_wrapper').find('.answer_errors').html(errors)
