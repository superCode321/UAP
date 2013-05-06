class CreateKvectors < ActiveRecord::Migration
  def change
    create_table :kvectors do |t|
      t.boolean :is_known
	  t.integer :view_count
	  
      t.timestamps
    end
  end
end