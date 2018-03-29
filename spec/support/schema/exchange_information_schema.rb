RSpec.shared_examples 'exchange_information_schema' do
  let(:schema) do
    {
        timezone: 'UTC',
        serverTime: a_kind_of(Integer),
        rateLimits: [{
                         rateLimitType: 'REQUESTS',
                         interval: 'MINUTE',
                         limit: 1200
                     },
                     {
                         rateLimitType: 'ORDERS',
                         interval: 'SECOND',
                         limit: 10
                     },
                     {
                         rateLimitType: 'ORDERS',
                         interval: 'DAY',
                         limit: 100_000
                     }],
        exchangeFilters: be_empty,
        symbols: all(
            match(
                symbol: match(/\w+/),
                status: 'TRADING',
                baseAsset: match(/\w+/),
                baseAssetPrecision: a_kind_of(Integer),
                quoteAsset: match(/\w+/),
                quotePrecision: a_kind_of(Integer),
                orderTypes: all(
                    match('LIMIT') |
                        match('LIMIT_MAKER') |
                        match('MARKET') |
                        match('STOP_LOSS_LIMIT') |
                        match('TAKE_PROFIT_LIMIT')
                ),
                icebergAllowed: eq(true) | eq(false),
                filters: all(
                    match(
                        filterType: 'PRICE_FILTER',
                        minPrice: match(/\d+\.\d+/),
                        maxPrice: match(/\d+\.\d+/),
                        tickSize: match(/\d+\.\d+/)
                    ) | match(
                        filterType: 'LOT_SIZE',
                        minQty: match(/\d+\.\d+/),
                        maxQty: match(/\d+\.\d+/),
                        stepSize: match(/\d+\.\d+/)
                    ) | match(
                        filterType: 'MIN_NOTIONAL',
                        minNotional: match(/\d+\.\d+/)
                    )
                )
            )
        )
    }
  end
end
