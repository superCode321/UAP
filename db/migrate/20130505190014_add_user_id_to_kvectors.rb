class AddUserIdToKvectors < ActiveRecord::Migration
  def change
    add_column :kvectors, :user_id, :integer
  end
end
