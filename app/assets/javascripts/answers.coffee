$ ->
  $(document).on 'click', '.answer-edit-form-trigger', (e) ->
    e.preventDefault()
    $(this).hide()
    $('.answer_form_wrapper').show()

  $(document).on 'ajax:success',
  'answer_form_wrapper .edit_answer',
  (e, data, status, xhr) ->
    $('.answer-edit-form-trigger').show()
    $('.answer_form_wrapper').hide()

  $(document).on 'ajax:success', '.answer .vote-up', (e, data, status, xhr) ->
    $('#answer_' + xhr.responseJSON.id + ' .vote-remove').show()
    $('#answer_' + xhr.responseJSON.id + ' .score').text(xhr.responseJSON.score)

  $(document).on 'ajax:success', '.answer .vote-down', (e, data, status, xhr) ->
    $('#answer_' + xhr.responseJSON.id + ' .vote-remove').show()
    $('#answer_' + xhr.responseJSON.id + ' .score').text(xhr.responseJSON.score)

  $(document).on 'ajax:success', '.answer .vote-remove', (e, data, status, xhr) ->
    $('#answer_' + xhr.responseJSON.id + ' .vote-remove').hide()
    $('#answer_' + xhr.responseJSON.id + ' .score').text(xhr.responseJSON.score)
