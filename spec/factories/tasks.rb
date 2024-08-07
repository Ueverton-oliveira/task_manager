FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence(word_count: 3) }
    status { Task.statuses.keys.sample }
    url { Faker::Internet.url }
    user_id { FactoryBot.create(:user).id }
    description { Faker::Lorem.paragraph(sentence_count: 4) }
    task_type { Task.task_types.keys.sample }
    association :user
  end
end
