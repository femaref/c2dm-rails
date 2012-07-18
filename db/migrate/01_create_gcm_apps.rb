class CreateGcmApps < ActiveRecord::Migration
  def self.up
    create_table :gcm_apps do |t|
      t.string :application_id
      t.string :sender_id
      t.string :source
      t.string :sender_auth_token
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :gcm_apps
  end
end