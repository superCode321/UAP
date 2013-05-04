class RemovePrivacySettingColumn < ActiveRecord::Migration
  def change
    remove_column :users, :privacy_setting
  end
end