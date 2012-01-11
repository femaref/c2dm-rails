rails_env = 'development'

if defined?(RAILS_ENV)
  rails_env = RAILS_ENV
end

C2DM.auth_url = 'https://www.google.com/accounts/ClientLogin'
C2DM.push_url = 'https://android.apis.google.com/c2dm/send'
C2DM.default_source = 'MyCompany-MyAppName-1.0'

base = File.join(File.dirname(__FILE__), 'app', 'models', 'c2dm', 'base.rb')
require base

Dir.glob(File.join(File.dirname(__FILE__), 'app', 'models', 'c2dm', '*.rb')).sort.each do |f|
  require f
end
