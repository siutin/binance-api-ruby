# frozen_string_literal: true

module BinanceAPI
  module Configuration
    DEFAULT_CONFIG = { testnet_mode: false }.freeze

    def configuration
      @configuration ||= OpenStruct.new(DEFAULT_CONFIG)
    end

    def configure
      yield(configuration)
    end
  end
end
