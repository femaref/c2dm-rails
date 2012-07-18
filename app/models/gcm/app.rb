class Gcm::App < Gcm::Base  
  self.table_name= "gcm_apps"
  
  has_many :devices, :class_name => "Gcm::Device", :dependent => :destroy
  has_many :batches, :class_name => "Gcm::Batch", :dependent => :destroy
  
  def deliver_batches
    connection = Gcm::Connection.new(self.source_auth_token)  
    
    self.batches.deliverable.each do |batch|
      self.deliver_batch batch, connection
    end 
  end
    
  def deliver_batch (batch, connection = nil)
    connection ||= Gcm::Connection.new(username, password, source)
    
    options = {
      :registration_ids => batch.notifications.deliverable.delete_if{ |n| n.should_wait? }.map{ |n| n.registration_id },
      :data => batch.data,
      :collapse_key => batch.collapse_key,
      :delay_while_idle => batch.delay_while_idle
      :time_to_live => batch.time_to_live
    }
    
    response = connection.send_batch(options)
  end
  
end