class DropWordTextModifier < ActiveRecord::Migration
  def change
  	 change_column :words, :text, :string, :limit => nil
  end

end
