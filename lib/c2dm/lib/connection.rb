require 'httparty'
require 'cgi'

module C2DM
  class Connection
    include HTTParty
    default_timeout 30

    attr_accessor :timeout, :username, :password, :source, :access_token

    def initialize(username=nil, password=nil, source=C2DM.default_source)
      @username = username
      @password = password
      @source   = source

      authenticate!
    end

    def authenticated?
      !@auth_token.nil?
    end

    def authenticate!
      auth_options = {
        'accountType' => 'HOSTED_OR_GOOGLE',
        'service'     => 'ac2dm',
        'Email'       => self.username,
        'Passwd'      => self.password,
        'source'      => self.source
      }
      post_body = build_post_body(auth_options)

      params = {
        :body    => post_body,
        :headers => {
          'Content-type'   => 'application/x-www-form-urlencoded',
          'Content-length' => post_body.length.to_s
        }
      }

      response = self.class.post(C2DM.auth_url, params)

      # check for authentication failures
      raise response.parsed_response if response['Error=']

      @auth_token = response.body.split("\n")[2].gsub('Auth=', '')
    end

    # {
    #   :registration_id => "...",
    #   :data => {
    #     :some_message => "Hi!", 
    #     :another_message => 7
    #   }
    #   :collapse_key => "optional collapse_key string"
    # }
    def send_notification(options)
      options[:collapse_key] ||= 'foo'
      post_body = build_post_body(options)

      params = {
        :body    => post_body,
        :headers => {
          'Authorization'  => "GoogleLogin auth=#{@auth_token}",
          'Content-type'   => 'application/x-www-form-urlencoded',
          'Content-length' => "#{post_body.length}"
        }
      }

      self.class.post(C2DM.push_url, params)
    end


  private
    def build_post_body(options={})
      post_body = []

      # data attributes need a key in the form of "data.key"...
      data_attributes = options.delete(:data)
      data_attributes.each_pair do |k,v|
        post_body << "data.#{k}=#{CGI::escape(v.to_s)}"
      end if data_attributes

      options.each_pair do |k,v|
        post_body << "#{k}=#{CGI::escape(v.to_s)}"
      end

      post_body.join('&')
    end

  end
end