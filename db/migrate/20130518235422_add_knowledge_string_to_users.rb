class AddKnowledgeStringToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :knowledge_string, :text
  end
end
