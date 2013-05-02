class CreateWords < ActiveRecord::Migration
  drop_table :words
  def change
    create_table :words do |t|
      t.string :text
	  t.integer :difficulty
	  
      t.timestamps
    end
  end
end