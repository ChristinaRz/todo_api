class CreateTodoItems < ActiveRecord::Migration[8.1]
  def change
    create_table :todo_items do |t|
      t.string :content
      t.boolean :completed
      t.references :todo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
