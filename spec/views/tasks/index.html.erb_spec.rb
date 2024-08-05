require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  let!(:user) { create(:user) }

  before(:each) do
    assign(:tasks, [
      Task.create!(
        name: Faker::Lorem.sentence(word_count: 3),
        status: Task.statuses.keys.sample,
        url: Faker::Internet.url,
        user_id: user.id,
        description: Faker::Lorem.paragraph(sentence_count: 4),
        task_type: Task.task_types.keys.sample
      ),
      Task.create!(
        name: Faker::Lorem.sentence(word_count: 3),
        status: Task.statuses.keys.sample,
        url: Faker::Internet.url,
        user_id: user.id,
        description: Faker::Lorem.paragraph(sentence_count: 4),
        task_type: Task.task_types.keys.sample
      )
    ])
  end

  it "renders a list of tasks" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("pending".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Url".to_s), count: 2
  end
end
