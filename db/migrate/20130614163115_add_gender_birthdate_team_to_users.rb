class AddGenderBirthdateTeamToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :birthdate, :date
    add_column :users, :team, :string
  end
end
