# frozen_string_literal: false

require 'rest-client'
require 'binance_api/base'
require 'binance_api/result'

module BinanceAPI
  # SAPI client for Ruby
  class SAPI < BinanceAPI::Base
    def deposit_address(params = {})
      params = map_params(params)
      process_request(:get, "#{base_url}/sapi/v1/capital/deposit/address", params)
    end

    def withdraw(params = {})
      params = map_params(params)
      process_request(:post, "#{base_url}/sapi/v1/capital/withdraw/apply", params)
    end

    def withdraw_history(params = {})
      params = map_params(params)
      process_request(:get, "#{base_url}/sapi/v1/capital/withdraw/history", params)
    end

    def coins_config(params = {})
      params = map_params(params)
      process_request(:get, "#{base_url}/sapi/v1/capital/config/getall", params)
    end
  end
end
