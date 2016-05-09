@App ||= {}
App.utils =
  errorsHandler: (selector, errors) ->
    all_errors = ''

    for message of errors
      all_errors += JST["templates/shared/errors"]({
        field: message,
        error: errors[message]
      })

    selector.html(all_errors)
