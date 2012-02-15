class CreateC2dmNotifications < ActiveRecord::Migration
  def self.up
    create_table :c2dm_notifications do |t|  
      t.string :collapse_key
      t.text :data
      t.boolean :delay_while_idle
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
    drop_table :c2dm_notifications
  end
end