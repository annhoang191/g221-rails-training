class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.string :content
      t.datetime :due_date
      t.integer :status, limit: 2, null: false, default: 0

      t.timestamps
    end
  end
end
