require 'rails_helper'

RSpec.describe Task, type: :model do
  it "is valid with valid attributes" do
    task = Task.new(title: "Sample Task", status: "pending", url: "http://example.com")
    expect(task).to be_valid
  end

  it "is not valid without a title" do
    task = Task.new(status: "pending", url: "http://example.com")
    expect(task).not_to be_valid
  end
end
