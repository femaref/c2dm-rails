class C2dm::Device < C2dm::Base  
  sself.table_name= "c2dm_devices"
  
  belongs_to :app, :class_name => "C2dm::App"
  has_many :notifications, :class_name => "C2dm::Notification", :dependent => :destroy
end