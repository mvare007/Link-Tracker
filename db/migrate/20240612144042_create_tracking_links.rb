class CreateTrackingLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracking_links do |t|
      t.string :tracking_code, null: false, index: { unique: true }
      t.references :client, null: false, foreign_key: true
      t.integer :visits_count, default: 0

      t.timestamps
    end
  end
end
