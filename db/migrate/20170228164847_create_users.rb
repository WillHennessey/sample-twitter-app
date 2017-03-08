class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email_address
      t.integer :team_id

      t.timestamps null: false
    end
  end
end
