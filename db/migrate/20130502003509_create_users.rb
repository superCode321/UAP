class CreateUsers < ActiveRecord::Migration
  drop_table :users
  def change
    create_table :users do |t|
      t.string :user_type
      t.string :username
      t.string :password
      t.string :password_hash
      t.string :password_salt
      t.string :privacy_setting
	  
      t.timestamps
    end
  end
end