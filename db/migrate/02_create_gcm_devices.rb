class CreateC2dmDevices < ActiveRecord::Migration
  def self.up
    create_table :gcm_devices do |t|
      t.string :registration_id
      t.integer :app_id
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :gcm_devices
  end
end