class RemoveLimitFromBody < ActiveRecord::Migration
  def change
  	change_column :articles, :body, :text, :limit => nil
  end
end
