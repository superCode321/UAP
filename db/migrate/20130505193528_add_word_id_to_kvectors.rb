class AddWordIdToKvectors < ActiveRecord::Migration
  def change
    add_column :kvectors, :word_id, :integer
  end
end
