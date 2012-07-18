class CreateC2dmNotifications < ActiveRecord::Migration
  def self.up
    create_table :gcm_notifications do |t|  
      t.integer :batch_id
      t.integer :device_id
    
      t.integer :message_id
      t.string :error
      t.boolean :deliver, :default => true
      t.datetime :sent_at
      t.integer :tries, :default => 0
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :gcm_notifications
  end
end