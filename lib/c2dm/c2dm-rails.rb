module C2dm
  rails_env = 'development'

  if defined?(RAILS_ENV)
    rails_env = RAILS_ENV
  end
  
  require File.join(File.dirname(__FILE__), "lib", "connection.rb")

  C2dm.auth_url = 'https://www.google.com/accounts/ClientLogin'
  C2dm.push_url = 'https://android.apis.google.com/c2dm/send'
  C2dm.default_source = 'MyCompany-MyAppName-1.0'

  base = File.join(File.dirname(__FILE__), 'app', 'models', 'c2dm', 'base.rb')
  require base

  Dir.glob(File.join(File.dirname(__FILE__), 'app', 'models', 'c2dm', '*.rb')).sort.each do |f|
    require f
  end
end