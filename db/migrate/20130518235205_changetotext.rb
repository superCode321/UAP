class Changetotext < ActiveRecord::Migration
  def up
  	change_column :words, :text, :text
  end

  def down
  end
end
