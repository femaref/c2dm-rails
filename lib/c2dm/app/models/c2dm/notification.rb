class C2dm::Notification < C2dm::Base
  belongs_to :device, :class_name => "C2dm::Device"
  
  serialize :data, Hash
  
  scope :deliverable, ->() { where(:deliver => true) }
end