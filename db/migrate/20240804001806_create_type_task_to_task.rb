class CreateTypeTaskToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :task_type, :integer
  end
end
