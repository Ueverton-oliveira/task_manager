require 'rails_helper'

RSpec.describe "tasks/show", type: :view do
  before(:each) do
    assign(:task, Task.create!(
      name: Faker::Lorem.sentence(word_count: 3),
      status: Task.statuses.keys.sample,
      url: Faker::Internet.url,
      user_id: FactoryBot.create(:user).id,
      description: Faker::Lorem.paragraph(sentence_count: 4),
      task_type: Task.task_types.keys.sample
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/pending/)
    expect(rendered).to match(/Url/)
  end
end
