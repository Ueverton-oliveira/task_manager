class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :status
      t.string :url

      t.timestamps
    end
  end
end
