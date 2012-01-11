require 'lib/connection'

module C2DM
  mattr_accessor :auth_url
  
  mattr_accessor :push_url
  
  mattr_accessor :default_source
end