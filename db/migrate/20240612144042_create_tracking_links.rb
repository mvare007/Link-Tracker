class CreateTrackingLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracking_links do |t|
      t.string :tracking_code, null: false, index: true
      t.references :client, null: false, foreign_key: true
      t.string :target_url, null: false
      t.integer :visits_count, default: 0

      t.timestamps
    end

    add_index :tracking_links, %i[tracking_code client_id], unique: true
  end
end
