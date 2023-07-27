require 'spec_helper'

RSpec.describe BinanceAPI::Base do
  subject(:base) { described_class.new }

  describe '#base_url' do
    subject(:method_call) { base.base_url }

    context 'when testnet_mode is set' do
      context 'when sandbox mode is set to true' do
        before do
          BinanceAPI.configure do |config|
            config.testnet_mode = true
          end
        end

        it 'returns testnet api url' do
          expect(method_call).to eq('https://testnet.binance.vision')
        end
      end

      context 'when sandbox mode is set to false' do
        before do
          BinanceAPI.configure do |config|
            config.testnet_mode = false
          end
        end

        it 'returns api base url' do
          expect(method_call).to eq('https://api.binance.com')
        end
      end
    end

    context 'when testnet_mode is not set' do
      it 'returns api base url' do
        expect(method_call).to eq('https://api.binance.com')
      end
    end
  end
end
