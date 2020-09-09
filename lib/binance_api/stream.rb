# frozen_string_literal: false

require 'websocket-client-simple'
module BinanceAPI
  class Stream
    BASE_ENDPOINT = 'wss://stream.binance.com:9443/'.freeze

    def initialize(endpoints, on_open: nil, on_close: nil, on_error: nil, on_message: nil)
      raise 'on_open can accept a block only' if !on_open.nil? && !on_open.is_a?(Proc)
      raise 'on_close can accept a block only' if !on_close.nil? && !on_close.is_a?(Proc)
      raise 'on_error can accept a block only' if !on_error.nil? && !on_error.is_a?(Proc)
      raise 'on_data can accept a block only' if !on_message.nil? && !on_message.is_a?(Proc)

      @endpoints = Array(endpoints).reject(&:nil?).reject(&:empty?)
      raise 'endpoints cannot be empty' if @endpoints.empty?

      @on_open = on_open
      @on_close = on_close
      @on_error = on_error
      @on_message = on_message
      @stream_type = @endpoints.length > 1 ? :combined : :single
    end

    def start
      @ws = WebSocket::Client::Simple.connect "#{BASE_ENDPOINT}#{stream_url}"
      ws.on :message, &on_message
      ws.on :open, &on_open
      ws.on :close, &on_close
      ws.on :error, &on_error
      ws
    end

    def close
      ws.close
    end

    protected

    attr_reader :ws, :endpoints, :stream_type

    def stream_url
      stream_type == :combined ? combined_url(endpoints) : single_url(endpoints.first)
    end

    def single_url(stream_name)
      "ws/#{stream_name}"
    end

    def combined_url(stream_names)
      "stream?streams=#{stream_names.join('/')}"
    end

    def on_open
      @on_open || ->() { puts "-- websocket open (#{url})" }
    end

    def on_close
      @on_close || ->(e) { puts "-- websocket close (#{e.inspect})" }
    end

    def on_error
      @on_error || ->(e) { puts "-- error (#{e.inspect})" }
    end

    def on_message
      @on_message || ->(msg) { puts ">> #{msg.data}" }
    end
  end
end
