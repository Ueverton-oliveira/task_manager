require 'rails_helper'

RSpec.describe Task, type: :model do
  it "is valid with valid attributes" do
    task = build(:task)
    expect(task).to be_valid
  end

  it "is not valid without a name" do
    task = build(:task, name: nil)
    expect(task).to_not be_valid
  end

  it "is not valid without a status" do
    task = build(:task, status: nil)
    expect(task).to_not be_valid
  end

  it "is not valid without a url" do
    task = build(:task, url: nil)
    expect(task).to_not be_valid
  end
end
