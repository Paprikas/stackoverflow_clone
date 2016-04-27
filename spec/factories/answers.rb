FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer body #{n}" }
    question

    factory :invalid_answer do
      body nil
      question nil
    end
  end
end
