RSpec.shared_examples 'order_schema' do
  let(:schema) do
    match(
      symbol: a_kind_of(String),
      orderId: a_kind_of(Integer),
      clientOrderId: a_kind_of(String),
      price: match(/\d+\.\d+/),
      origQty: match(/\d+\.\d+/),
      executedQty: match(/\d+\.\d+/),
      status: match('NEW') |
          match('PARTIALLY_FILLED') |
          match('FILLED') |
          match('CANCELED') |
          match('PENDING_CANCEL') |
          match('REJECTED') |
          match('EXPIRED'),
      timeInForce: match('GTC') | match('IOC') | match('FOK'),
      type: match('LIMIT') |
          match('MARKET') |
          match('STOP_LOSS') |
          match('STOP_LOSS_LIMIT') |
          match('TAKE_PROFIT') |
          match('TAKE_PROFIT_LIMIT') |
          match('LIMIT_MAKER'),
      side: match('BUY') | match('SELL'),
      stopPrice: match(/\d+\.\d+/),
      icebergQty: match(/\d+\.\d+/),
      time: a_kind_of(Integer),
      isWorking: eq(true) | eq(false)
    )
  end
end
