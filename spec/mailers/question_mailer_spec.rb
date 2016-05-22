require "rails_helper"

RSpec.describe QuestionMailer, type: :mailer do
  let(:questions) { create_list(:question, 2) }

  describe "digest", :users do
    let(:mail) { described_class.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily Questions Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello! Here is the digest of new questions for last 24 hours!")
      expect(mail.body.encoded).to match(questions.first.title)
      expect(mail.body.encoded).to match(questions.second.title)
      expect(mail.body.encoded).to match(url_for(questions.first))
      expect(mail.body.encoded).to match(url_for(questions.second))
    end
  end

  describe "new_answer", :users do
    let(:question) { questions.first }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { described_class.new_answer(user, question, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer for question \"#{question.title}\"")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New answer for question \"#{question.title}\":")
      expect(mail.body.encoded).to match(answer.body)
      expect(mail.body.encoded).to match("Click on the following link to view question online:")
      expect(mail.body.encoded).to match(url_for(question))
    end
  end

  describe "update" do
    let(:mail) { described_class.update }

    it "renders the headers" do
      expect(mail.subject).to eq("Update")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
