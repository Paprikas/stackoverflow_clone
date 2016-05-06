update_score = (el, xhr) ->
  resource = $(el).data('resource-type') + '_' + xhr.responseJSON.id
  $('#votable_' + resource + ' .score').text(xhr.responseJSON.score)
  
  if xhr.responseJSON.voted
    $('#votable_' + resource + ' .vote-remove').show()
    $('#votable_' + resource + ' .vote-change').hide()
  else
    $('#votable_' + resource + ' .vote-remove').hide()
    $('#votable_' + resource + ' .vote-change').show()

$ ->
  $(document).on 'ajax:success', '.voting', (e, data, status, xhr) ->
    update_score(this, xhr)
