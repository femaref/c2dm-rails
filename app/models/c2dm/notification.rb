class C2dm::Notification < C2dm::Base
  set_table_name "c2dm_notifications"
  
  belongs_to :device, :class_name => "C2dm::Device"
  
  serialize :data, Hash
  
  scope :deliverable, ->() { where(:deliver => true) }
end