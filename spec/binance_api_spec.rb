RSpec.describe BinanceAPI do
  it "has a version number" do
    expect(BinanceAPI::VERSION).not_to be nil
  end

  let(:client) { BinanceAPI.new }
  context 'Returns a BinanceAPI::Client' do
    it { expect(client).to be_a_kind_of(BinanceAPI::Client) }
  end

  context '#ping' do
    subject { client.ping }
    it { is_expected.to have_attributes(value: {}) }
    it { expect(subject.success?).to be_truthy }
  end

  context '#server_time' do
    subject { client.server_time }
    it { is_expected.to have_attributes(value: { serverTime: a_kind_of(Integer) }) }
    it { expect(subject.success?).to be_truthy }
  end

  context '#depth' do
    subject { client.depth('BTCUSDT', limit: 5) }
    it {
      is_expected.to have_attributes(value: match(
          lastUpdateId: a_kind_of(Integer),
          bids: all(match_array([
                                    match(/\d+\.\d+/), # PRICE
                                    match(/\d+\.\d+/), # QTY
                                    be_empty           # Ignore
                                ])),
          asks: all(match_array([
                                    match(/\d+\.\d+/),
                                    match(/\d+\.\d+/),
                                    be_empty
                                ]))
      ))
    }
    it { expect(subject.value[:bids].size).to eq(5) }
    it { expect(subject.value[:asks].size).to eq(5) }
    it { expect(subject.success?).to be_truthy }
  end

  context '#exchange_info' do
    subject { client.exchange_info }
    it_behaves_like 'exchange_information_schema' do
      it { is_expected.to have_attributes(value: schema) }
    end
    it { expect(subject.success?).to be_truthy }
  end
end
