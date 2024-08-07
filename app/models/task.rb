class Task < ApplicationRecord
  belongs_to :user


  validates :name, presence: true
  validates :status, presence: true
  validates :task_type, presence: true
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }
  validates :description, presence: true

  enum status: {
    pending: 0,
    in_progress: 1,
    completed: 2,
    failed: 3
  }

  enum task_type: {
    story: 0,
    task: 1,
    bug: 2
  }
end
