require 'binance_api/version'
require 'binance_api/client'

module BinanceAPI

  class << self

    def new
      @client = BinanceAPI::Client.new
    end

    attr_reader :client

  end

end
