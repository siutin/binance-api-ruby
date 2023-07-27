# frozen_string_literal: false

require 'rest-client'
require 'date'
require 'uri'
require 'json'
require 'binance_api/base'
require 'binance_api/result'

module BinanceAPI
  class REST < BinanceAPI::Base
    def account(params = {})
      params = map_params(params)
      process_request(:get, "#{base_url}/api/v3/account", params)
    end

    def ticker_price(params = {})
      req_params = { symbol: params[:symbol], without_auth: true }
      process_request(:get, "#{base_url}/api/v3/ticker/price", req_params)
    end

    def ping
      response = safe { RestClient.get("#{base_url}/api/v1/ping") }
      build_result response
    end

    def server_time
      response = safe { RestClient.get("#{base_url}/api/v1/time") }
      build_result response
    end

    def exchange_info
      response = safe { RestClient.get("#{base_url}/api/v1/exchangeInfo") }
      build_result response
    end

    def depth(symbol, limit: 100)
      response = safe { RestClient.get("#{base_url}/api/v1/depth", params: { symbol: symbol, limit: limit }) }
      build_result response
    end

    def trades(symbol, limit: 500)
      response = safe { RestClient.get("#{base_url}/api/v1/trades", params: { symbol: symbol, limit: limit }) }
      build_result response
    end

    def historical_trades(symbol, limit: 500, from_id: nil)
      params = { symbol: symbol, limit: limit }
      params = params.merge(fromId: from_id) unless from_id.nil?
      response = safe do
        RestClient.get "#{base_url}/api/v1/historicalTrades",
                       params: params,
                       'X-MBX-APIKEY' => api_key
      end
      build_result response
    end

    def aggregate_trades_list(symbol, from_id: nil, start_time: nil, end_time: nil, limit: 500)
      params = begin
        { symbol: symbol, limit: limit }.tap do |_params|
          _params[:fromId] = from_id unless from_id.nil?
          _params[:startTime] = start_time unless start_time.nil?
          _params[:endTime] = end_time unless end_time.nil?
        end
      end
      response = safe { RestClient.get("#{base_url}/api/v1/aggTrades", params: params) }
      build_result response
    end

    def klines(symbol, interval, start_time: nil, end_time: nil, limit: 500)
      params = begin
        { symbol: symbol, interval: interval, limit: limit }.tap do |_params|
          _params[:startTime] = start_time unless start_time.nil?
          _params[:endTime] = end_time unless end_time.nil?
        end
      end

      response = safe { RestClient.get("#{base_url}/api/v1/klines", params: params) }
      build_result response
    end

    def ticker_24hr(symbol)
      response = safe { RestClient.get("#{base_url}/api/v1/ticker/24hr", params: { symbol: symbol }) }
      build_result response
    end

    def ticker_book(symbol)
      response = safe { RestClient.get("#{base_url}/api/v3/ticker/bookTicker", params: { symbol: symbol }) }
      build_result response
    end

    def order(params = {})
      params = map_params(params)
      process_request(:post, "#{base_url}/api/v3/order", params)
    end

    def order_test(params = {})
      params = map_params(params)
      process_request(:post, "#{base_url}/api/v3/order/test", params)
    end

    def get_order(params = {})
      params = map_params(params)
      process_request(:get, "#{base_url}/api/v3/order", params)
    end

    def cancel_order(params = {})
      params = map_params(params)
      process_request(:delete, "#{base_url}/api/v3/order", params)
    end

    def open_orders(params = {})
      params = map_params(params)
      process_request(:get, "#{base_url}/api/v3/openOrders", params)
    end

    def all_orders(params = {})
      params = map_params(params)
      process_request(:get, "#{base_url}/api/v3/allOrders", params)
    end

    def my_trades(symbol, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now
      limit = options.delete(:limit) || 500
      params = {
          symbol: symbol,
          limit: limit,
          fromId: options.fetch(:from_id, nil),
          recvWindow: recv_window,
          timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{base_url}/api/v3/myTrades",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def start_user_data_stream
      response = safe do
        RestClient.post "#{base_url}/api/v1/userDataStream",
                        {},
                        'X-MBX-APIKEY' => api_key
      end
      build_result response
    end

    def keep_alive_user_data_stream(listen_key)
      response = safe do
        RestClient.put "#{base_url}/api/v1/userDataStream",
                       {listenKey: listen_key},
                       'X-MBX-APIKEY' => api_key
      end
      build_result response
    end

    def close_user_data_stream(listen_key)
      response = safe do
        RestClient.delete "#{base_url}/api/v1/userDataStream",
                          params: {listenKey: listen_key},
                          'X-MBX-APIKEY' => api_key
      build_result response
      end
    end

    protected

    def build_result(response)
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

  end
end
