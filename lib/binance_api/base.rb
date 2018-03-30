require 'rest-client'
require 'date'
require 'uri'
require 'json'
require 'binance_api/result'

module BinanceAPI
  class Base
    BASE_URL = 'https://api.binance.com'.freeze

    protected

    def params_with_signature(params, secret)
      params = params.reject { |_k, v| v.nil? }
      query_string = URI.encode_www_form(params)
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, query_string)
      params = params.merge(signature: signature)
    end

    # ensure to return a response object
    def safe
      yield
    rescue RestClient::ExceptionWithResponse => err
      return err.response
    end

    def config
      @config ||= BinanceAPI.load_config
    end

    def api_key
      config['API_KEY'].freeze
    end

    def api_secret
      config['API_SECRET'].freeze
    end
  end
end