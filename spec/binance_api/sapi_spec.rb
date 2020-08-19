require 'spec_helper'

RSpec.describe BinanceAPI::SAPI, :vcr do
  subject(:sapi_client) { BinanceAPI::SAPI.new }

  describe '.deposit_address' do
    context 'when valid params' do
      it 'returns result with expected keys' do
        result = sapi_client.deposit_address(coin: 'USDT', network: 'OMNI')
        expect(result.value).to include(:address, :coin, :tag, :url)
      end
    end

    context 'when invalid params' do
      it 'throws BinanceAPI::RequestError' do
        expect { sapi_client.deposit_address(coin: 'MOJCOIN') }.to(
          raise_error(BinanceAPI::RequestError)
        )
      end

      it 'throws exception with error message' do
        sapi_client.deposit_address(coin: 'MOJCOIN')
      rescue => e
        expect(e.message).to include('The deposit has been closed')
      end

      it 'throws exception with status code' do
        sapi_client.deposit_address(coin: 'MOJCOIN')
      rescue => e
        expect(e.status).to eq(400)
      end
    end
  end
end
