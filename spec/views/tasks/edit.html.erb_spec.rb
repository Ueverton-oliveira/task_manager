require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  let!(:user) { create(:user) }
  let(:task) {
    Task.create!(
      name: Faker::Lorem.sentence(word_count: 3),
      status: Task.statuses.keys.sample,
      url: Faker::Internet.url,
      user_id: FactoryBot.create(:user).id,
      description: Faker::Lorem.paragraph(sentence_count: 4),
      task_type: Task.task_types.keys.sample
    )
  }

  before(:each) do
    assign(:task, task)
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", task_path(task), "post" do

      assert_select "input[name=?]", "task[name]"

      assert_select "input[name=?]", "task[status]"

      assert_select "input[name=?]", "task[url]"
    end
  end
end
