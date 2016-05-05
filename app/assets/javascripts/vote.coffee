update_score = (el, xhr) ->
  resource = $(el).data('resource-type') + '_' + xhr.responseJSON.id
  $('#votable_' + resource + ' .score').text(xhr.responseJSON.score)

$ ->
  $(document).on 'ajax:success', '.voting', (e, data, status, xhr) ->
    update_score(this, xhr)
