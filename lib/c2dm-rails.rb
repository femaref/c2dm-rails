module C2dm
  mattr_accessor :auth_url
  mattr_accessor :push_url
  
  @@auth_url = 'https://www.google.com/accounts/ClientLogin'
  @@push_url = 'https://android.apis.google.com/c2dm/send'
  
  def self.setup
    yield self
  end
  
  class Engine < Rails::Engine
    engine_name "c2dm"
    
    config.c2dm = C2dm
    
    initializer "c2dm.initialize" do |app|
      app.config.c2dm = C2dm
    end
  end
end