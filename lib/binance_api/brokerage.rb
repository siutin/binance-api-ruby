require 'rest-client'
require 'binance_api/base'
require 'binance_api/result'

module BinanceAPI
  class Brokerage < BinanceAPI::Base
    def create_subaccount(options = {})
      params = base_params(options)

      process_request(:post, "#{BASE_URL}/sapi/v1/broker/subAccount", params)
    end

    def get_subaccount(subaccount_id = nil, options = {})
      params = base_params(options).merge(
        subAccountId: subaccount_id
      )

      process_request(:get, "#{BASE_URL}/sapi/v1/broker/subAccount", params)
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
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def base_params(options)
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      {
        recvWindow: recv_window,
        timestamp: timestamp.to_i * 1000
      }
    end
  end
end
