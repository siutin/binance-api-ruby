require 'rest-client'
require 'date'
require 'uri'
require 'json'
require 'binance_api/result'

module BinanceAPI
  class Base
    BASE_URL = 'https://api.binance.com'.freeze

    def initialize(options: {})
      @api_key = options.fetch(:api_key, nil)
      @api_secret = options.fetch(:api_secret, nil)
    end

    attr_writer :api_key, :api_secret

    def api_key
      @api_key || BinanceAPI.api_key || raise('missing api_key')
    end

    def api_secret
      @api_secret || BinanceAPI.api_secret || raise('missing api_secret')
    end

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
  end
end
