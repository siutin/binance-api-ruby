require 'binance_api/version'
require 'binance_api/client'
require 'binance_api/stream'
require 'yaml'

module BinanceAPI
  class << self
    def new
      @client = BinanceAPI::Client.new
    end

    attr_reader :client

    def load_config
      YAML.load_file(File.join(BinanceAPI.root, 'config', 'config.yml'))
    end

    def root
      File.expand_path('../..', __FILE__)
    end
  end
end
