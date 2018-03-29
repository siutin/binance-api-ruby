require 'rest-client'
require 'json'
require 'binance_api/result'

module BinanceAPI
  class Client
    BASE_URL = 'https://api.binance.com'.freeze

    def ping
      response = RestClient.get("#{BASE_URL}/api/v1/ping")
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def server_time
      response = RestClient.get("#{BASE_URL}/api/v1/time")
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def exchange_info
      response = RestClient.get("#{BASE_URL}/api/v1/exchangeInfo")
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def depth(symbol, limit: 100)
      response = RestClient.get("#{BASE_URL}/api/v1/depth", params: {symbol: symbol, limit: limit})
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def trades(symbol, limit: 500)
      response = RestClient.get("#{BASE_URL}/api/v1/trades", params: {symbol: symbol, limit: limit})
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def historical_trades(symbol, limit: 500, from_id: nil)
      params = {symbol: symbol, limit: limit}
      params = params.merge(fromId: from_id) unless from_id.nil?
      response = RestClient.get "#{BASE_URL}/api/v1/historicalTrades", params: params, 'X-MBX-APIKEY' => ''
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def aggregate_trades_list(symbol, from_id: nil, start_time: nil, end_time: nil, limit: 500)
      params = begin
        {symbol: symbol, limit: limit}.tap do |_params|
          _params[:fromId] = from_id unless from_id.nil?
          _params[:startTime] = start_time unless start_time.nil?
          _params[:endTime] = end_time unless end_time.nil?
        end
      end
      response = RestClient.get("#{BASE_URL}/api/v1/aggTrades", params: params)
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def klines(symbol, interval, start_time: nil, end_time: nil, limit: 500)
      params = begin
        {symbol: symbol, interval: interval, limit: limit}.tap do |_params|
          _params[:startTime] = start_time unless start_time.nil?
          _params[:endTime] = end_time unless end_time.nil?
        end
      end

      response = RestClient.get("#{BASE_URL}/api/v1/klines", params: params)
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def ticker_24hr(symbol)
      response = RestClient.get("#{BASE_URL}/api/v1/ticker/24hr", params: {symbol: symbol})
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def ticker_price(symbol)
      response = RestClient.get("#{BASE_URL}/api/v3/ticker/price", params: {symbol: symbol})
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

    def ticker_book(symbol)
      response = RestClient.get("#{BASE_URL}/api/v3/ticker/bookTicker", params: {symbol: symbol})
      json = JSON.parse(response.body, symbolize_names: true)
      BinanceAPI::Result.new(json, response.code == 200)
    end

  end
end