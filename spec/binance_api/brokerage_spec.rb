require 'spec_helper'

RSpec.describe BinanceAPI::Brokerage, :vcr do
  subject(:brokerage) { BinanceAPI::Brokerage.new }

  describe '.create_subaccount' do
    context 'when success response' do
      it 'returns result with created subaccount id' do
        result = brokerage.create_subaccount

        expect(result.value[:subaccountId]).to be_a(String)
      end
    end

    context 'when error response' do
      before { brokerage.api_secret = 'INVALID_SECRET' }

      it 'throws BinanceAPI::RequestError' do
        expect { brokerage.create_subaccount }.to raise_error(BinanceAPI::RequestError)
      end

      it 'throws exception with error message and code' do
        brokerage.create_subaccount
      rescue => e
        expect(e.message).to include('Signature for this request is not valid')
        expect(e.status).to eq(400)
      end
    end
  end

  describe '.get_subaccount' do
    context 'when valid subaccount ID' do
      let(:subaccount_id) { '494553304457687040' }

      it 'returns result with expected keys' do
        result = brokerage.get_subaccount(subaccount_id)

        expect(result.value.first.keys).to include(:subaccountId, :createTime, :makerCommission)
      end
    end

    context 'when invalid subaccount ID' do
      let(:subaccount_id) { '-1' }

      it 'throws BinanceAPI::RequestError' do
        expect { brokerage.get_subaccount(subaccount_id) }.to raise_error(BinanceAPI::RequestError)
      end

      it 'throws exception with error message and code' do
        brokerage.get_subaccount(subaccount_id)
      rescue => e
        expect(e.message).to include('This two users are not in parent-child relation')
        expect(e.status).to eq(400)
      end
    end
  end
end
