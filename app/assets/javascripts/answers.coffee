$ ->
  $('.delete-answer').on 'ajax:success', ->
    $(this).closest('.answer').remove();
