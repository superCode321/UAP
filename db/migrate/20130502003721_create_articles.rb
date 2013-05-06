class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
	  t.string :body
	  t.string :source_url
	  
      t.timestamps
    end
  end
end