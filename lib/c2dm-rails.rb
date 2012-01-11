require 'rails'

module C2dm
  mattr_accessor :auth_url
  
  mattr_accessor :push_url
  
  mattr_accessor :default_source
end

require 'c2dm/c2dm-rails'