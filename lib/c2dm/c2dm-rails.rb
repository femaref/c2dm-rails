module C2dm
  require File.join(File.dirname(__FILE__), "lib", "connection.rb")

  C2dm.auth_url = 'https://www.google.com/accounts/ClientLogin'
  C2dm.push_url = 'https://android.apis.google.com/c2dm/send'
end