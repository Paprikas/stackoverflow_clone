class QuestionMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email
  end

  def new_answer(user, question, answer)
    @question = question
    @answer = answer
    mail to: user.email, subject: t('question_mailer.new_answer.subject', question_title: question.title)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_mailer.update.subject
  #
  def update
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
