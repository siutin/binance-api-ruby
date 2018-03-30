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

    def load_config
      YAML.load_file(File.join(BinanceAPI.root, 'config', 'config.yml'))
    end

    def root
      File.expand_path('../..', __FILE__)
    end
  end
end
