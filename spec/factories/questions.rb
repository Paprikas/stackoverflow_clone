FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    sequence(:body) { |n| "Good question body #{n}" }

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
