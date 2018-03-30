RSpec.describe BinanceAPI::REST do
  let(:rest) { BinanceAPI.rest }
  context 'Returns a BinanceAPI::REST' do
    it { expect(rest).to be_a_kind_of(BinanceAPI::REST) }
  end

  context '#ping' do
    subject { rest.ping }
    it { is_expected.to have_attributes(value: {}) }
    it { expect(subject.success?).to be_truthy }
  end

  context '#server_time' do
    subject { rest.server_time }
    it { is_expected.to have_attributes(value: { serverTime: a_kind_of(Integer) }) }
    it { expect(subject.success?).to be_truthy }
  end

  context '#exchange_info' do
    subject { rest.exchange_info }
    it_behaves_like 'exchange_information_schema' do
      it { is_expected.to have_attributes(value: schema) }
    end
    it { expect(subject.success?).to be_truthy }
  end

  context '#depth' do
    subject { rest.depth('BTCUSDT', limit: 5) }
    it {
      is_expected.to have_attributes(value: match(
        lastUpdateId: a_kind_of(Integer),
        bids: all(match_array([
                                match(/\d+\.\d+/), # PRICE
                                match(/\d+\.\d+/), # QTY
                                be_empty # Ignore
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

  context '#trades' do
    subject { rest.trades('BTCUSDT', limit: 5) }
    it {
      is_expected.to have_attributes(
        value: all(
          match(
            id: a_kind_of(Integer),
            price: match(/\d+\.\d+/),
            qty: match(/\d+\.\d+/),
            time: a_kind_of(Integer),
            isBuyerMaker: eq(true) | eq(false),
            isBestMatch: eq(true) | eq(false)
          )
        )
      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#historical_trades' do
    subject { rest.historical_trades('BTCUSDT', limit: 5) }
    it {
      is_expected.to have_attributes(
        value: all(
          match(
            id: a_kind_of(Integer),
            price: match(/\d+\.\d+/),
            qty: match(/\d+\.\d+/),
            time: a_kind_of(Integer),
            isBuyerMaker: eq(true) | eq(false),
            isBestMatch: eq(true) | eq(false)
          )
        )

      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#aggregate_trades_list' do
    subject { rest.aggregate_trades_list('BTCUSDT', limit: 5) }
    it {
      is_expected.to have_attributes(
        value: all(
          match(
            a: a_kind_of(Integer),
            p: match(/\d+\.\d+/),
            q: match(/\d+\.\d+/),
            f: a_kind_of(Integer),
            l: a_kind_of(Integer),
            T: a_kind_of(Integer),
            m: eq(true) | eq(false),
            M: eq(true) | eq(false)
          )
        )

      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#klines' do
    subject { rest.klines('BTCUSDT', '1w', limit: 5) }
    it {
      is_expected.to have_attributes(
        value: all(
          match_array([
                        a_kind_of(Integer), # Open Time
                        match(/\d+\.\d+/), # Open
                        match(/\d+\.\d+/), # High
                        match(/\d+\.\d+/), # Low
                        match(/\d+\.\d+/), # Close
                        match(/\d+\.\d+/), # Volume
                        a_kind_of(Integer), # Close time
                        match(/\d+\.\d+/), # Quote asset volume
                        a_kind_of(Integer), # Number of trades
                        match(/\d+\.\d+/), # Taker buy base asset volume
                        match(/\d+\.\d+/), # Taker buy quote asset volume
                        '0' # Ignore
                      ])
        )

      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#ticker_24hr' do
    subject { rest.ticker_24hr('BTCUSDT') }
    it {
      is_expected.to have_attributes(
        value: match(
          symbol: a_kind_of(String),
          priceChange: match(/(-?)\d+\.\d+/),
          priceChangePercent: match(/(-?)\d+\.\d+/),
          weightedAvgPrice: match(/\d+\.\d+/),
          prevClosePrice: match(/\d+\.\d+/),
          lastPrice: match(/\d+\.\d+/),
          lastQty: match(/\d+\.\d+/),
          bidPrice: match(/\d+\.\d+/),
          bidQty: match(/\d+\.\d+/),
          askPrice: match(/\d+\.\d+/),
          askQty: match(/\d+\.\d+/),
          openPrice: match(/\d+\.\d+/),
          highPrice: match(/\d+\.\d+/),
          lowPrice: match(/\d+\.\d+/),
          volume: match(/\d+\.\d+/),
          quoteVolume: match(/\d+\.\d+/),
          openTime: a_kind_of(Integer),
          closeTime: a_kind_of(Integer),
          firstId: a_kind_of(Integer), # First tradeId
          lastId: a_kind_of(Integer), # Last tradeId
          count: a_kind_of(Integer) # Trade count
        )
      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#ticker_price' do
    subject { rest.ticker_price('BTCUSDT') }
    it {
      is_expected.to have_attributes(
        value: match(
          symbol: a_kind_of(String),
          price: match(/\d+\.\d+/)
        )
      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#ticker_book' do
    subject { rest.ticker_book('BTCUSDT') }
    it {
      is_expected.to have_attributes(
        value: match(
          symbol: a_kind_of(String),
          bidPrice: match(/\d+\.\d+/),
          bidQty: match(/\d+\.\d+/),
          askPrice: match(/\d+\.\d+/),
          askQty: match(/\d+\.\d+/),
        )
      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#order_test' do
    subject { rest.order_test('BNBBTC', 'BUY', 'MARKET', 1) }
    it { is_expected.to have_attributes(value: {}) }
    it { expect(subject.success?).to be_truthy }
  end

  pending "new order spec"
  pending "query order spec"
  pending "cancel order spec"
  
  context '#open_orders' do
    subject { rest.open_orders('BNBUSDT') }
    it_behaves_like 'order_schema' do
      it { is_expected.to have_attributes(value: all(schema)) }
    end
    it { expect(subject.success?).to be_truthy }
  end

  context '#all_orders' do
    subject { rest.all_orders('BTCUSDT', limit: 5) }
    it_behaves_like 'order_schema' do
      it { is_expected.to have_attributes(value: all(schema)) }
    end
    it { expect(subject.success?).to be_truthy }
  end

  context '#account' do
    subject { rest.account }
    it {
      is_expected.to have_attributes(
        value: match(

          makerCommission: a_kind_of(Integer),
          takerCommission: a_kind_of(Integer),
          buyerCommission: a_kind_of(Integer),
          sellerCommission: a_kind_of(Integer),
          canTrade:  eq(true) | eq(false),
          canWithdraw:  eq(true) | eq(false),
          canDeposit:  eq(true) | eq(false),
          updateTime: a_kind_of(Integer),
          balances: all(
            match(
              asset: a_kind_of(String),
              free: match(/\d+\.\d+/),
              locked: match(/\d+\.\d+/)

            )
          )
        )
      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#my_trades' do
    subject { rest.my_trades('BTCUSDT') }
    it {
      is_expected.to have_attributes(
        value: all(
          match(
            id: a_kind_of(Integer),
            orderId: a_kind_of(Integer),
            price: match(/\d+\.\d+/),
            qty: match(/\d+\.\d+/),
            commission: match(/\d+\.\d+/),
            commissionAsset: a_kind_of(String),
            time: a_kind_of(Integer),
            isBuyer: eq(true) | eq(false),
            isMaker: eq(true) | eq(false),
            isBestMatch: eq(true) | eq(false),
          )
        )
      )
    }
    it { expect(subject.success?).to be_truthy }
  end
end
