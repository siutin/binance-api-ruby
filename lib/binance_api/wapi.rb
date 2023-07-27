# frozen_string_literal: false

require 'rest-client'
require 'binance_api/base'
require 'binance_api/result'

module BinanceAPI
  class WAPI < BinanceAPI::Base
    def withdraw(asset, address, amount, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
        asset: asset,
        address: address,
        addressTag: options.fetch(:address_tag, nil),
        amount: amount,
        name: options.fetch(:name, nil),
        recvWindow: recv_window,
        timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{base_url}/wapi/v3/withdraw.html",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def deposit_history(asset, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
        asset: asset,
        status: options.fetch(:status, nil),
        startTime: options.fetch(:start_time, nil),
        endTime: options.fetch(:end_time, nil),
        recvWindow: recv_window,
        timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{base_url}/wapi/v3/depositHistory.html",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def withdraw_history(asset, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
        asset: asset,
        status: options.fetch(:status, nil),
        startTime: options.fetch(:start_time, nil),
        endTime: options.fetch(:end_time, nil),
        recvWindow: recv_window,
        timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{base_url}/wapi/v3/withdrawHistory.html",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def deposit_address(asset, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
        asset: asset,
        status: options.fetch(:status, nil),
        recvWindow: recv_window,
        timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{base_url}/wapi/v3/depositAddress.html",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def withdraw_fee(asset, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
        asset: asset,
        recvWindow: recv_window,
        timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{base_url}/wapi/v3/withdrawFee.html",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def account_status(options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
        recvWindow: recv_window,
        timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{base_url}/wapi/v3/accountStatus.html",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def system_status
      response = safe { RestClient.get("#{base_url}/wapi/v3/systemStatus.html") }

      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    protected

    def build_result(response)
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200 && json.fetch(:success, false))
    end

  end
end
