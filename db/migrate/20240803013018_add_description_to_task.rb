class AddDescriptionToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :description, :text
  end
end
