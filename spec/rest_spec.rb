RSpec.describe BinanceAPI::REST, :vcr do
  subject(:rest) { BinanceAPI::REST.new }

  context '#account' do
    it 'matches schema' do
      expect(rest.account.value[:balances].first).to include(:asset, :free, :locked)
    end

    it { expect(rest.account.success?).to be_truthy }

    context 'when error response' do
      before { rest.api_secret = 'INVALID_SECRET' }

      it 'throws BinanceAPI::RequestError' do
        expect { rest.account }.to raise_error(BinanceAPI::RequestError)
      end

      it 'throws exception with error message and code' do
        rest.account
      rescue => e
        expect(e.message).to include('Signature for this request is not valid')
        expect(e.status).to eq(400)
      end
    end
  end
end
