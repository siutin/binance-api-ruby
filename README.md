# binance-api-ruby

A wrapper written in ruby for Binance API

## Installation

Manually install using [RubyGems](http://rubygems.org/):

```
gem install binance_api
```

Or add it to your Gemfile:

```
gem 'binance_api'
```

## Configuration

You may want to test the API behaviour for some development/testing purposes. Then you should add following configuration:
```
# config/initializers/binance.rb

BinanceAPI.configure do |config|
  config.testnet_mode = true
end
```
For production, you can skip this section. `testnet_mode` by default is set to `false`

## Examples

### using a REST Client
```
require 'binance_api'

# initialize a rest client
rest_client = BinanceAPI::REST.new

result = rest_client.ticker_24hr('BNBBTC')
#<BinanceAPI::Result:0x000000000220c7c0 ... >

>> result.success?
true

# return a response value in Hash
>> result.value
{ :symbol=>"BNBBTC",  :priceChange=>"0.00003640", :priceChangePerce .... }

```

## get last 5 BNB/BTC orders

```
 # fill in your profile
 client.api_key = 'YOUR_API_KEY'
 client.api_secret = 'YOUR_API_SECRET'

 >> client.all_orders('BNBBTC', limit: 10).value
 [{:symbol=>"BNBBTC", :orderId=>25456733, :clientOrderId=>"ios_a323664543576765623787ybdfsdcax1231d", :price=>"0.00128567", :origQty=>"12.1000000", ...}, {...]

```

### using a Stream client

```
require 'binance_api'

# initialize a combined stream client
stream = BinanceAPI::Stream.new(['bnbbtc@aggTrade', 'bnbbtc@trade'], on_message: ->(msg) { puts "message: #{msg.data}" })

>> stream.start
 -- websocket open (wss://stream.binance.com:9443/stream?streams=bnbbtc@aggTrade/bnbbtc@trade)
 message: {"stream":"bnbbtc@aggTrade","data":{"e":"aggTrade","E":1522436817258,"s":"BNBBTC","a":11744566,"p":"0.00147820","q":"0.15000000","f":13627823,"l":13627823,"T":1522436817255,"m":false,"M":true}}
 message: {"stream":"bnbbtc@trade","data":{"e":"trade","E":1522436817257,"s":"BNBBTC","t":13627823,"p":"0.00147820","q":"0.15000000","b":35456123,"a":35456121,"T":1522436817255,"m":false,"M":true}}
 message: {"stream":"bnbbtc@trade","data":{"e":"trade","E":1522436819021,"s":"BNBBTC","t":13627824,"p":"0.00147820","q":"2.63000000","b":35456125,"a":35456121,"T":1522436819021,"m":false,"M":true}}
 message: {"stream":"bnbbtc@aggTrade","data":{"e":"aggTrade","E":1522436819022,"s":"BNBBTC","a":11744567,"p":"0.00147820","q":"2.63000000","f":13627824,"l":13627824,"T":1522436819021,"m":false,"M":true}}
 message: {"stream":"bnbbtc@aggTrade","data":{"e":"aggTrade","E":1522436823612,"s":"BNBBTC","a":11744568,"p":"0.00147660","q":"24.88000000","f":13627825,"l":13627826,"T":1522436823609,"m":true,"M":true}}
 message: {"stream":"bnbbtc@trade","data":{"e":"trade","E":1522436823611,"s":"BNBBTC","t":13627825,"p":"0.00147660","q":"0.01000000","b":35456076,"a":35456136,"T":1522436823609,"m":true,"M":true}}
 message: {"stream":"bnbbtc@trade","data":{"e":"trade","E":1522436823611,"s":"BNBBTC","t":13627826,"p":"0.00147660","q":"24.87000000","b":35456127,"a":35456136,"T":1522436823609,"m":true,"M":true}}
 ...


```

### Using Proxy

You can use proxy parameter:

- In initializer in every module inherited from BinanceAPI::Base: BinanceAPI::Brokerage, BinanceAPI::REST, BinanceAPI::SAPI, BinanceAPI::WAPI
- In params of every method of these modules

## Structure

API | Class
------ | --------
Rest API | BinanceAPI::REST
Withdrawal API | BinanceAPI::WAPI
WebSocket Stream | BinanceAPI::Stream

## REST Client Calls

    #ping
    #server_time
    #exchange_info
    #depth
    #trades
    #historical_trades
    #aggregate_trades_list
    #klines
    #ticker_24hr
    #ticker_price
    #ticker_book
    #order
    #order_test
    #get_order
    #cancel_order
    #open_orders
    #all_orders
    #account
    #my_trades
    #start_user_data_stream
    #keep_alive_user_data_stream
    #close_user_data_stream

## Withdrawal Client Calls
    #withdraw
    #deposit_history
    #withdraw_history
    #deposit_address
    #withdraw_fee
    #account_status
    #system_status

## Stream Client Calls

    #close
    #start

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Donations

If this repo made you feel useful in any way, you can always leave me a tips at:
```
 BNB: 0x607cb799cb2e9b777e1453d4f2450eae738fd342
 BTC: 1LwjLrBwQtpCiWKCpfJ4JhYq3bkMerdjXU
```
