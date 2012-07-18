require "gcm-rails"
require "connection"

module Gcm
  mattr_accessor :push_url
  
  @@push_url = 'https://android.googleapis.com/gcm/send'
  
  def self.setup
    yield self
  end
  
  class Engine < Rails::Engine
    engine_name "gcm"
    
    config.gcm = Gcm
    
    initializer "gcm.initialize" do |app|
      app.config.gcm = Gcm
    end
  end
end