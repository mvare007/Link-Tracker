class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.references :tracking_link, null: false, foreign_key: true
      t.string :ip_address, null: false
      t.string :user_agent, null: false

      t.timestamps
    end
  end
end
