FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence }
    status { %w[pendente em progresso concluída falha].sample }
    url { Faker::Internet.url }
  end
end
