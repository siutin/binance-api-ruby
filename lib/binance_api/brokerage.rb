# frozen_string_literal: false

require 'rest-client'
require 'binance_api/base'
require 'binance_api/result'

module BinanceAPI
  # Brokerage API client
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

    def subaccount_transfer(params = {})
      params = map_params(params)
      process_request(:post, "#{BASE_URL}/sapi/v1/broker/transfer", params)
    end
  end
end
