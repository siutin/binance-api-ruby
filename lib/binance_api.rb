# frozen_string_literal: false

require 'binance_api/version'
require 'binance_api/configuration'
require 'binance_api/request_error'
require 'binance_api/rest'
require 'binance_api/wapi'
require 'binance_api/stream'
require 'binance_api/brokerage'
require 'binance_api/sapi'
require 'yaml'

# BinanceAPI client builders
module BinanceAPI
  extend Configuration

  class << self
    def rest
      @rest ||= BinanceAPI::REST.new
    end

    def wapi
      @wapi ||= BinanceAPI::WAPI.new
    end

    def brokerage
      @brokerage ||= BinanceAPI::Brokerage.new
    end

    def sapi
      @sapi ||= BinanceAPI::SAPI.new
    end

    attr_writer :recv_window

    def recv_window
      @recv_window || 5000
    end

    attr_accessor :api_key, :api_secret, :proxy
  end
end
