require 'httparty'
require 'cgi'

module Gcm
  class Connection
    include HTTParty
    default_timeout 30

    attr_accessor :sender_auth_token

    def initialize(sender_auth_token)
      @sender_auth_token = sender_auth_token
    end

    # {
    #   :registration_id => "...",
    #   :data => {
    #     :some_message => "Hi!", 
    #     :another_message => 7
    #   }
    #   :collapse_key => "optional collapse_key string"
    # }
    def send_batch(options)
      options[:collapse_key] ||= 'default'
      post_body = options.to_json

      params = {
        :body    => post_body,
        :headers => {
          'Authorization'  => "key=#{self.sender_auth_token}",
          'Content-type'   => 'application/json',
          'Content-length' => "#{post_body.length}"
        }
      }

      self.class.post(Gcm.push_url, params)
    end
  end
end