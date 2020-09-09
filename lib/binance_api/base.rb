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
      @proxy = options.fetch(:proxy, nil)
    end

    attr_writer :api_key, :api_secret, :proxy

    def api_key
      @api_key || BinanceAPI.api_key || raise('missing api_key')
    end

    def api_secret
      @api_secret || BinanceAPI.api_secret || raise('missing api_secret')
    end

    def proxy
      @proxy || BinanceAPI.proxy
    end

    protected

    def params_with_signature(params, secret)
      params = params.reject { |_k, v| v.nil? }
      query_string = URI.encode_www_form(params)
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, query_string)
      params.merge(signature: signature)
    end

    def process_request(method, url, params)
      response = make_request(method, url, params)
      validate_response(response)
      build_result response
    end

    def make_request(method, url, params)
      signed_params = params_with_signature(params, api_secret)
      headers = { 'X-MBX-APIKEY' => api_key }
      execute_params = { method: method, url: url, proxy: proxy || params.delete(:proxy) }
      safe do
        if method == :get
          RestClient::Request
            .execute(execute_params.merge(headers: headers.merge(params: signed_params)))
        else
          RestClient::Request
            .execute(execute_params.merge(payload: signed_params, headers: headers))
        end
      end
    end

    def validate_response(response)
      return if response.code == 200

      raise BinanceAPI::RequestError.new(response.code, response.body)
    end

    def build_result(response)
      json = JSON.parse(response.body&.empty? ? '{}' : response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def map_params(options)
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      options.transform_keys! { |k| snake_case_to_camel_case(k) }

      options.merge(recvWindow: recv_window, timestamp: timestamp.to_i * 1000)
    end

    def snake_case_to_camel_case(key)
      %w[_ \s].each do |s|
        key = key.to_s.gsub(/(?:#{s}+)([a-z])/) { Regexp.last_match(1).upcase }
      end
      key.gsub(/(\A|\s)([A-Z])/) { Regexp.last_match(1) + Regexp.last_match(2).downcase }.to_sym
    end

    # ensure to return a response object
    def safe
      yield
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
