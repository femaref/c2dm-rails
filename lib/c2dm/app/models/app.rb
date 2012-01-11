class C2DM::App < C2DM::Base
  has_many :devices, :class_name => "C2DM::Device", :dependent => :destroy
  has_many :notifications, :through => :devices, :dependent => :destroy
  
  def send_notifications
    connection = C2DM::Connection.new(username, password, source)
    
    self.notifications.sendable.each { |notification| send_notification(notification, connection) }
  end
  
  def send_notification (notification, connection = nil)
    connection ||= C2DM::Connection.new(username, password, source)
    
    options = {
      :registration_id => notification.device.registration_id,
      :data => notification.data,
      :collapse_key => notification.collapse_key
      :delay_while_idle => notification.delay_while_idle
    }
    
    response = connection.send_notification(options)
        
    answer = Hash[response.body.scan(/(\w+)=(\w+)/).map{ |a| [a[0].downcase.to_sym, a[1]]}]
    
    notification.message_id = answer[:id]
    notification.sent_at = Time.now
    notification.send = false
    
    if response.response.code == 200 # request executed correctly
      if answer.has_key? :error        
        notification.error = answer[:error]
        
        # these are recoverable errors
        if notification.error == "QuotaExceeded" || notification.error == "DeviceQuotaExceeded"
          notification.send = true
        end
      end          
    elsif response.response.code == 503 # service not available, resend message later
      notification.send = true
      notification.error = "Service temporarily unavailable"
    elsif response.response.code == 401 # wrong api credentials
      notification.error = "wrong authtoken, check corresponding login"   
    else
      notification.error = "unknown error"
    end
    
    notification.save
  end
  
end