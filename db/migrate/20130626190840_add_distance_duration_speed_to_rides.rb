class AddDistanceDurationSpeedToRides < ActiveRecord::Migration
  def change
    add_column :rides, :distance, :decimal
    add_column :rides, :duration, :string
    add_column :rides, :speed, :decimal
  end
end
