class C2dm::App < C2dm::Base  
  set_table_name "c2dm_apps"
  
  has_many :devices, :class_name => "C2dm::Device", :dependent => :destroy
  has_many :notifications, :through => :devices, :dependent => :destroy
  
  def deliver_notifications
    connection = C2dm::Connection.new(username, password, source)
    
    self.notifications.deliverable.each do |notification|
      if (notification.sent_at + (10 ** notification.tries).seconds) < Time.now
        deliver_notification(notification, connection)
    end
    end
      
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
          notification.try += 1
          if notification.try <= 4
            notification.deliver = true
          else
            notification.error = "TriesExceeded"
          end
        end
        
        # not a device connected with this app, delete it
        if notification.error == "InvalidRegistration" || notification.error == "NotRegistered"
          notification.device.delete
        end
        
      end          
    elsif response.response.code == 503 # service not available, redeliver message later
      notification.error = "Service temporarily unavailable"
      
      notification.try += 1
      
      if notification.try <= 4
        notification.deliver = true
      else
        notification.error = "TriesExceeded"
      end
      
    elsif response.response.code == 401 # wrong api credentials
      notification.error = "wrong authtoken, check corresponding login"   
    else
      notification.error = "unknown error"
    end
    
    notification.save
  end
  
end