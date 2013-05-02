class CreateKvectors < ActiveRecord::Migration
  def change
    create_table :kvectors do |t|

      t.timestamps
    end
  end
end
