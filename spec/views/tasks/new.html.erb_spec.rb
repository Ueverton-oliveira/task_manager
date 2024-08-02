require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  before(:each) do
    assign(:task, Task.new(
      name: "MyString",
      status: "MyString",
      url: "MyString"
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
