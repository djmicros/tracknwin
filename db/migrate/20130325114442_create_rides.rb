class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.text :body
      t.integer :user_id

      t.timestamps
    end
    add_index :rides, [:user_id, :created_at]
  end
end
