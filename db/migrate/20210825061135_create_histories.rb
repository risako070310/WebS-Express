class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.float :x
      t.float :y
      t.timestamps null: false
    end
  end
end
