class C2dm::App < C2dm::Base  
  has_many :devices, :class_name => "C2dm::Device", :dependent => :destroy
  has_many :notifications, :through => :devices, :dependent => :destroy
  
  def deliver_notifications
    connection = C2dm::Connection.new(username, password, source)
    
    self.notifications.deliverable.each { |notification| deliver_notification(notification, connection) }
  end
  
  def deliver_notification (notification, connection = nil)
    connection ||= C2dm::Connection.new(username, password, source)
    
    options = {
      :registration_id => notification.device.registration_id,
      :data => notification.data,
      :collapse_key => notification.collapse_key,
      :delay_while_idle => notification.delay_while_idle
    }
    
    response = connection.send_notification(options)
        
    answer = Hash[response.body.scan(/(\w+)=(\w+)/).map{ |a| [a[0].downcase.to_sym, a[1]]}]
    
    notification.message_id = answer[:id]
    notification.sent_at = Time.now
    notification.deliver = false
    
    if response.response.code == 200 # request executed correctly
      if answer.has_key? :error        
        notification.error = answer[:error]
        
        # these are recoverable errors
        if notification.error == "QuotaExceeded" || notification.error == "DeviceQuotaExceeded"
          notification.deliver = true
        end
      end          
    elsif response.response.code == 503 # service not available, redeliver message later
      notification.deliver = true
      notification.error = "Service temporarily unavailable"
    elsif response.response.code == 401 # wrong api credentials
      notification.error = "wrong authtoken, check corresponding login"   
    else
      notification.error = "unknown error"
    end
    
    notification.save
  end
  
end