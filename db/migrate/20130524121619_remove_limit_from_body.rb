class RemoveLimitFromBody < ActiveRecord::Migration
  def change
  	change_column :article, :body, :text, :limit => nil
  end
end
