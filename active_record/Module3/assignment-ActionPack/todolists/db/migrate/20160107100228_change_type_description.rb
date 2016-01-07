class ChangeTypeDescription < ActiveRecord::Migration
  def up
    change_table :todo_items do |t|
      t.change :description, :text
    end
  end
  def down
    change_table :todo_items do |t|
      t.change :description, :string
    end
  end
end
