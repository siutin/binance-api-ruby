require 'rest-client'
require 'binance_api/base'
require 'binance_api/result'

module BinanceAPI
  class Brokerage < BinanceAPI::Base
    def create_subaccount(params = {})
      params = map_params(params)
      process_request(:post, "#{BASE_URL}/sapi/v1/broker/subAccount", params)
    end

    def get_subaccount(params = {})
      params = map_params(params)
      process_request(:get, "#{BASE_URL}/sapi/v1/broker/subAccount", params)
    end

    def create_subaccount_key(params = {})
      params = map_params(params)
      process_request(:post, "#{BASE_URL}/sapi/v1/broker/subAccountApi", params)
    end

    def delete_subaccount_key(params = {})
      params = map_params(params)
      process_request(:delete, "#{BASE_URL}/sapi/v1/broker/subAccountApi", params)
    end

    def deposit_history(params = {})
      params = map_params(params)
      process_request(:get, "#{BASE_URL}/sapi/v1/broker/subAccount/depositHist", params)
    end

    protected

    def process_request(method, url, params)
      response = make_request(method, url, params)
      validate_response(response)
      build_result response
    end

    def make_request(method, url, params)
      signed_params = params_with_signature(params, api_secret)
      headers = { 'X-MBX-APIKEY' => api_key }
      safe do
        if method == :get
          RestClient.get url, headers.merge(params: signed_params)
        else
          RestClient::Request.execute(
            method: method,
            url: url,
            payload: signed_params,
            headers: headers
          )
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
      ['_', '\s'].each do |s|
        key = key.to_s.gsub(/(?:#{s}+)([a-z])/){ $1.upcase }
      end
      key.gsub(/(\A|\s)([A-Z])/){ $1 + $2.downcase }.to_sym
    end
  end
end
