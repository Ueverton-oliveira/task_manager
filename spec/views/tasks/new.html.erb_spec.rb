require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  let!(:user) { create(:user) }

  before(:each) do
    assign(:task, Task.new(
      name: Faker::Lorem.sentence(word_count: 3),
      status: Task.statuses.keys.sample,
      url: Faker::Internet.url,
      user_id: FactoryBot.create(:user).id,
      description: Faker::Lorem.paragraph(sentence_count: 4),
      task_type: Task.task_types.keys.sample
    ))
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", tasks_path, "post" do

      assert_select "input[name=?]", "task[name]"

      assert_select "input[name=?]", "task[status]"

      assert_select "input[name=?]", "task[url]"
    end
  end
end
