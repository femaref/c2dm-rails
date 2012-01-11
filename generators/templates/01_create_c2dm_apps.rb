class CreateC2dmApps < ActiveRecord::Migration
  def self.up
    create_table :c2dm_apps do |t|
      t.string :username
      t.string :password
      t.string :application_id
      t.string :sender_id
      t.string :source
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :c2dm_apps
  end
end