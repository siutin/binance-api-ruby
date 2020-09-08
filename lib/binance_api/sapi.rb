require 'rest-client'
require 'binance_api/base'
require 'binance_api/result'

module BinanceAPI
  class SAPI < BinanceAPI::Base
    def deposit_address(params = {})
      params = map_params(params)
      process_request(:get, "#{BASE_URL}/sapi/v1/capital/deposit/address", params)
    end

    def withdraw(params = {})
      params = map_params(params)
      process_request(:post, "#{BASE_URL}/sapi/v1/capital/withdraw/apply", params)
    end

    def withdraw_history(params = {})
      params = map_params(params)
      process_request(:get, "#{BASE_URL}/sapi/v1/capital/withdraw/history", params)
    end
  end
end
