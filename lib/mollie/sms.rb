require "digest/md5"
require "uri"
require "net/http"

module Mollie
  class SMS
    GATEWAY_URI = URI.parse("http://www.mollie.nl/xml/sms")

    GATEWAYS = {
      :basic         => '2',
      :business      => '4',
      :business_plus => '1',
      :landline      => '8'
    }

    class << self
      attr_accessor :username, :password, :charset, :type, :gateway

      def password=(password)
        @password = Digest::MD5.hexdigest(password)
      end

      def request_params
        {
          'username'     => @username,
          'md5_password' => @password,
          'gateway'      => @gateway,
          'charset'      => @charset,
          'type'         => @type
        }
      end
    end

    self.charset = 'UTF-8'
    self.type    = 'normal'
    self.gateway = GATEWAYS[:basic]    

    attr_accessor :telephone_number, :body

    def request_params
      self.class.request_params.merge('recipients' => @telephone_number, 'message' => @body)
    end

    def deliver
      Net::HTTP.post_form(GATEWAY_URI, request_params)
    end
  end
end