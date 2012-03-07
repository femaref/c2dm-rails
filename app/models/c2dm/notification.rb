class C2dm::Notification < C2dm::Base
  self.table_name= "c2dm_notifications"
  
  belongs_to :device, :class_name => "C2dm::Device"
  
  serialize :data, Hash
  
  scope :deliverable, lambda { where(:deliver => true) }
  
  def should_wait?
    sent_at && ((sent_at + (10 ** tries).seconds) >= Time.now)
  end
end