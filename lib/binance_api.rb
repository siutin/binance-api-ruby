require 'binance_api/version'
require 'binance_api/rest'
require 'binance_api/wapi'
require 'binance_api/stream'
require 'yaml'

module BinanceAPI
  class << self

    def rest
      @rest ||= BinanceAPI::REST.new
    end

    def wapi
      @wapi ||= BinanceAPI::WAPI.new
    end

    attr_writer :recv_window

    def recv_window
      @recv_window || 5000
    end

    attr_accessor :api_key, :api_secret

  end
end
