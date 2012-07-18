class Gcm::Batch < Gcm::Base
  self.table_name = "gcm_batches"

  has_many :notifications, :class_name => "Gcm::Notifications"
  has_one :app, :class_name => "Gcm::App"
  
  scope :deliverable, lambda { where(:deliver => true) }
  
  def deliverable?
    !self.notifications.deliverable.empty?
  end
end