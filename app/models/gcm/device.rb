class Gcm::Device < Gcm::Base  
  self.table_name= "gcm_devices"
  
  belongs_to :app, :class_name => "Gcm::App"
  has_many :notifications, :class_name => "Gcm::Notification", :dependent => :destroy
end