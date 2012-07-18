class Gcm::Notification < Gcm::Base
  self.table_name= "gcm_notifications"
  
  belongs_to :device, :class_name => "Gcm::Device"
  
  serialize :data, Hash
  
  scope :deliverable, lambda { where(:deliver => true) }
  
  def should_wait?
    sent_at && ((sent_at + (10 ** tries).seconds) >= Time.now)
  end
end