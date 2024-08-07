require 'faker'

# Limpar dados existentes (opcional)
Task.destroy_all

# Criar um usuário padrão (opcional)
user = User.create(email: 'ueverton.souz@gmail.com', name: 'Ueverton')

# Gerar dados de exemplo usando Faker e sample para enums
20.times do
  task = Task.create(
    name: Faker::Lorem.sentence(word_count: 3),
    status: Task.statuses.keys.sample,
    url: Faker::Internet.url,
    user_id: user.id,
    description: Faker::Lorem.paragraph(sentence_count: 4),
    task_type: Task.task_types.keys.sample,
    user_id: user.id
  )
end

puts "Tasks geradas com sucesso!"