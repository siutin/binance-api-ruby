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
        result = brokerage.get_subaccount(sub_account_id: subaccount_id)

        expect(result.value.first.keys).to include(:subaccountId, :createTime, :makerCommission)
      end
    end

    context 'when invalid subaccount ID' do
      let(:subaccount_id) { '-1' }

      it 'throws BinanceAPI::RequestError' do
        expect { brokerage.get_subaccount(sub_account_id: subaccount_id) }.to(
          raise_error(BinanceAPI::RequestError)
        )
      end

      it 'throws exception with error message and code' do
        brokerage.get_subaccount(sub_account_id: subaccount_id)
      rescue => e
        expect(e.message).to include('This two users are not in parent-child relation')
        expect(e.status).to eq(400)
      end
    end
  end

  describe '.create_subaccount_key' do
    let(:api_call) do
      brokerage.create_subaccount_key(sub_account_id: subaccount_id, can_trade: can_trade)
    end

    context 'when valid subaccount ID' do
      let(:subaccount_id) { '495279769361068032' }
      let(:can_trade) { true }

      it 'returns result with expected keys' do
        result = api_call
        expect(result.value.keys).to(
          include(:apiKey, :secretKey, :subaccountId, :canTrade, :marginTrade, :futuresTrade)
        )
      end
    end

    context 'when invalid subaccount ID' do
      let(:subaccount_id) { '-1' }
      let(:can_trade) { true }

      it 'throws BinanceAPI::RequestError' do
        expect { api_call }.to(
          raise_error(BinanceAPI::RequestError)
        )
      end

      it 'throws exception with error message' do
        api_call
      rescue => e
        expect(e.message).to include('This two users are not in parent-child relation')
      end

      it 'throws exception with error code' do
        api_call
      rescue => e
        expect(e.status).to eq(400)
      end
    end

    context 'when mandatory param is missing' do
      let(:subaccount_id) { '495279769361068032' }
      let(:can_trade) { nil }

      it 'throws BinanceAPI::RequestError' do
        expect { api_call }.to(
          raise_error(BinanceAPI::RequestError)
        )
      end

      it 'throws exception with error message' do
        api_call
      rescue => e
        expect(e.message).to include("Mandatory parameter 'canTrade is not null' was not sent")
      end

      it 'throws exception with error code' do
        api_call
      rescue => e
        expect(e.status).to eq(400)
      end
    end
  end

  describe '.delete_subaccount_key' do
    let(:api_call) do
      brokerage.delete_subaccount_key(sub_account_id: subaccount_id, sub_account_api_key: api_key)
    end

    context 'when valid params' do
      let(:subaccount_id) { '495279769361068032' }
      let(:api_key) { 'CgXjYwP2AwWapJKEyKqbZ1BgcOtFkrUBomefbrw2hDGLyigvrEL4i7DXpc5ofjQM' }

      it 'returns result with expected keys' do
        result = api_call
        expect(result.value).to be_eql({})
      end
    end

    context 'when API key does not exist' do
      let(:subaccount_id) { '495279769361068032' }
      let(:api_key) { 'CgXjYwP2AwWapJKEyKqbZ1BgcOtFkrUBomefbrw2hDGLyigvrEL4i7DXpc5ofjQM' }

      it 'throws BinanceAPI::RequestError' do
        expect { api_call }.to(
          raise_error(BinanceAPI::RequestError)
        )
      end

      it 'throws exception with error message and code' do
        api_call
      rescue => e
        expect(e.message).to include('API key does not exist')
      end

      it 'throws exception with error code' do
        api_call
      rescue => e
        expect(e.status).to eq(400)
      end
    end

    context 'when invalid subaccount ID' do
      let(:subaccount_id) { '-1' }
      let(:api_key) { 'CgXjYwP2AwWapJKEyKqbZ1BgcOtFkrUBomefbrw2hDGLyigvrEL4i7DXpc5ofjQM' }

      it 'throws BinanceAPI::RequestError' do
        expect { api_call }.to(
          raise_error(BinanceAPI::RequestError)
        )
      end

      it 'throws exception with error message and code' do
        api_call
      rescue => e
        expect(e.message).to include('This two users are not in parent-child relation')
      end

      it 'throws exception with error code' do
        api_call
      rescue => e
        expect(e.status).to eq(400)
      end
    end

    context 'when mandatory param is missing' do
      let(:subaccount_id) { '495279769361068032' }
      let(:api_key) { nil }

      it 'throws BinanceAPI::RequestError' do
        expect { api_call }.to(
          raise_error(BinanceAPI::RequestError)
        )
      end

      it 'throws exception with error message' do
        api_call
      rescue => e
        expect(e.message).to include("Mandatory parameter 'subAccountApiKey is not null' was not sent")
      end

      it 'throws exception with error code' do
        api_call
      rescue => e
        expect(e.status).to eq(400)
      end
    end
  end

  describe '.deposit_history' do
    let(:api_call) do
      brokerage.deposit_history(params)
    end

    context 'when valid params' do
      let(:subaccount_id) { '495279769361068032' }
      let(:params) { { sub_account_id: subaccount_id } }

      it 'returns result with expected keys' do
        result = api_call
        expect(result.value).to be_eql([])
      end
    end

    context 'when invalid subaccount ID' do
      let(:subaccount_id) { '-1' }
      let(:params) { { sub_account_id: subaccount_id } }

      it 'throws BinanceAPI::RequestError' do
        expect { api_call }.to(
          raise_error(BinanceAPI::RequestError)
        )
      end

      it 'throws exception with error message and code' do
        api_call
      rescue => e
        expect(e.message).to include('This two users are not in parent-child relation')
      end

      it 'throws exception with error code' do
        api_call
      rescue => e
        expect(e.status).to eq(400)
      end
    end
  end
end
