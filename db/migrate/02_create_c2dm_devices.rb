class CreateC2dmDevices < ActiveRecord::Migration
  def self.up
    create_table :c2dm_devices do |t|
      t.string :registration_id
      t.integer :app_id
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :c2dm_devices
  end
end