class CreateGcmBatches < ActiveRecord::Migration
  def change
    create_table :gcm_batches do |t|
      t.string :collapse_key
      t.text :data
      t.boolean :delay_while_idle
      t.integer :time_to_live
      
      t.boolean :deliver
      
      t.timestamps
    end
  end
end