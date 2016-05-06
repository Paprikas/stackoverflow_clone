$ ->
  $('.open-comment-form').on 'click', (e) ->
    e.preventDefault()
    $('.comment-form').show()
    $('.open-comment-form').hide()

  $(document).on 'ajax:success', '.new_comment', (e, data, status, xhr) ->
    $(this).closest('.comments').append('<div class=\"comment\">' + xhr.responseJSON.comment + '</div>')
    $(this).closest('.comments').find('.comment_errors').text('')
    $('.comment-form textarea').val('')
    $('.comment-form').hide()
    $('.open-comment-form').show()
  .on 'ajax:error', '.new_comment', (e, xhr) ->
    errors = ''
    for error in xhr.responseJSON.errors
      do (error) ->
        errors += '<p>' + error + '</p>'
    $(this).closest('.comments').find('.comment_errors').html(errors)
