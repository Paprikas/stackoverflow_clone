update_score = (el, xhr) ->
  resource = $(el).data('resource-type')
  $('#votable_' + resource + '_' + xhr.responseJSON.id + ' .score').text(xhr.responseJSON.score)

$ ->
  $(document).on 'ajax:success', '.voting', (e, data, status, xhr) ->
    update_score(this, xhr)
