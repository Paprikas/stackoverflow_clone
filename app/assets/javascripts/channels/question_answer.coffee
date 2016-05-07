App.question_answer = App.cable.subscriptions.create "QuestionAnswerChannel",
  question: -> $('[data-question-channel]')

  connected: ->
    setTimeout =>
      @followCurrentPage()
      @installPageChangeCallback()
    , 1000

  disconnected: ->

  received: (data) ->
    console.log data
    $('.answers').append(data.answer)

  followCurrentPage: ->
    if questionId = @question().data('question-channel')
      @perform 'follow', question_id: questionId
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'page:change', -> App.question_answer.followCurrentPage()
