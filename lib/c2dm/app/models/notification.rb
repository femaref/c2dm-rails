class C2DM::Notification < C2DM::Base
  belongs_to :device, :class_name => "C2DM::Device"
  
  serialize :data, Hash
  
  scope :sendable, -> (notification) { where(:send => true)}
end