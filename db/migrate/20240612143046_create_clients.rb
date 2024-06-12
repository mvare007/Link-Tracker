class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :store_url, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
