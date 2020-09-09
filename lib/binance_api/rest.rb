# frozen_string_literal: false

require 'rest-client'
require 'date'
require 'uri'
require 'json'
require 'binance_api/base'
require 'binance_api/result'

module BinanceAPI
  class REST < BinanceAPI::Base
    def ping
      response = safe { RestClient.get("#{BASE_URL}/api/v1/ping") }
      build_result response
    end

    def server_time
      response = safe { RestClient.get("#{BASE_URL}/api/v1/time") }
      build_result response
    end

    def exchange_info
      response = safe { RestClient.get("#{BASE_URL}/api/v1/exchangeInfo") }
      build_result response
    end

    def depth(symbol, limit: 100)
      response = safe { RestClient.get("#{BASE_URL}/api/v1/depth", params: { symbol: symbol, limit: limit }) }
      build_result response
    end

    def trades(symbol, limit: 500)
      response = safe { RestClient.get("#{BASE_URL}/api/v1/trades", params: { symbol: symbol, limit: limit }) }
      build_result response
    end

    def historical_trades(symbol, limit: 500, from_id: nil)
      params = { symbol: symbol, limit: limit }
      params = params.merge(fromId: from_id) unless from_id.nil?
      response = safe do
        RestClient.get "#{BASE_URL}/api/v1/historicalTrades",
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
      response = safe { RestClient.get("#{BASE_URL}/api/v1/aggTrades", params: params) }
      build_result response
    end

    def klines(symbol, interval, start_time: nil, end_time: nil, limit: 500)
      params = begin
        { symbol: symbol, interval: interval, limit: limit }.tap do |_params|
          _params[:startTime] = start_time unless start_time.nil?
          _params[:endTime] = end_time unless end_time.nil?
        end
      end

      response = safe { RestClient.get("#{BASE_URL}/api/v1/klines", params: params) }
      build_result response
    end

    def ticker_24hr(symbol)
      response = safe { RestClient.get("#{BASE_URL}/api/v1/ticker/24hr", params: { symbol: symbol }) }
      build_result response
    end

    def ticker_price(symbol)
      response = safe { RestClient.get("#{BASE_URL}/api/v3/ticker/price", params: { symbol: symbol }) }
      build_result response
    end

    def ticker_book(symbol)
      response = safe { RestClient.get("#{BASE_URL}/api/v3/ticker/bookTicker", params: { symbol: symbol }) }
      build_result response
    end

    # {
    #     symbol: 'LTCBTC',
    #     side: 'BUY',
    #     type: 'LIMIT',
    #     timeInForce: 'GTC',
    #     quantity: 1,
    #     price: 0.1,
    #     recvWindow: BinanceAPI.recv_window,
    #     timestamp: 1499827319559
    # }

    def order(symbol, side, type, quantity, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
          symbol: symbol,
          side: side,
          type: type,
          timeInForce: options.fetch(:time_in_force, nil),
          quantity: quantity,
          price: options.fetch(:price, nil),
          newClientOrderId: options.fetch(:new_client_order_id, nil),
          stopPrice: options.fetch(:stop_price, nil),
          icebergQty: options.fetch(:iceberg_qty, nil),
          newOrderRespType: options.fetch(:new_order_resp_type, nil),
          recvWindow: recv_window,
          timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.post "#{BASE_URL}/api/v3/order",
                        params_with_signature(params, api_secret),
                        'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def order_test(symbol, side, type, quantity, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
        symbol: symbol,
        side: side,
        type: type,
        timeInForce: options.fetch(:time_in_force, nil),
        quantity: quantity,
        price: options.fetch(:price, nil),
        newClientOrderId: options.fetch(:new_client_order_id, nil),
        stopPrice: options.fetch(:stop_price, nil),
        icebergQty: options.fetch(:iceberg_qty, nil),
        newOrderRespType: options.fetch(:new_order_resp_type, nil),
        recvWindow: recv_window,
        timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.post "#{BASE_URL}/api/v3/order/test",
                        params_with_signature(params, api_secret),
                        'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def get_order(symbol, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
          symbol: symbol,
          orderId: options.fetch(:order_id, nil),
          origClientOrderId: options.fetch(:orig_client_order_id, nil),
          recvWindow: recv_window,
          timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{BASE_URL}/api/v3/order",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def cancel_order(symbol, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
          symbol: symbol,
          orderId: options.fetch(:order_id, nil),
          origClientOrderId: options.fetch(:orig_client_order_id, nil),
          newClientOrderId: options.fetch(:new_client_order_id, nil),
          recvWindow: recv_window,
          timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.delete "#{BASE_URL}/api/v3/order",
                          params: params_with_signature(params, api_secret),
                          'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def open_orders(symbol, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
          symbol: symbol,
          recvWindow: recv_window,
          timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{BASE_URL}/api/v3/openOrders",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def all_orders(symbol, options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now
      limit = options.delete(:limit) || 500

      params = {
          symbol: symbol,
          orderId: options.fetch(:order_id, nil),
          limit: limit,
          recvWindow: recv_window,
          timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{BASE_URL}/api/v3/allOrders",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end


    def account(options = {})
      recv_window = options.delete(:recv_window) || BinanceAPI.recv_window
      timestamp = options.delete(:timestamp) || Time.now

      params = {
          recvWindow: recv_window,
          timestamp: timestamp.to_i * 1000 # to milliseconds
      }

      response = safe do
        RestClient.get "#{BASE_URL}/api/v3/account",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
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
        RestClient.get "#{BASE_URL}/api/v3/myTrades",
                       params: params_with_signature(params, api_secret),
                       'X-MBX-APIKEY' => api_key
      end

      build_result response
    end

    def start_user_data_stream
      response = safe do
        RestClient.post "#{BASE_URL}/api/v1/userDataStream",
                        {},
                        'X-MBX-APIKEY' => api_key
      end
      build_result response
    end

    def keep_alive_user_data_stream(listen_key)
      response = safe do
        RestClient.put "#{BASE_URL}/api/v1/userDataStream",
                       {listenKey: listen_key},
                       'X-MBX-APIKEY' => api_key
      end
      build_result response
    end

    def close_user_data_stream(listen_key)
      response = safe do
        RestClient.delete "#{BASE_URL}/api/v1/userDataStream",
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
