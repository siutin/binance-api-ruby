# frozen_string_literal: false

require 'spec_helper'

RSpec.describe BinanceAPI::SAPI, :vcr do
  subject(:subject) { BinanceAPI::SAPI.new }

  describe '.deposit_address' do
    context 'when valid params' do
      it 'returns result with expected keys' do
        result = subject.deposit_address(coin: 'USDT', network: 'OMNI')
        expect(result.value).to include(:address, :coin, :tag, :url)
      end
    end

    context 'when invalid params' do
      it_behaves_like 'correctly handles invalid api response', :deposit_address
    end
  end

  describe '.withdraw' do
    context 'when valid params' do
      # When executing without VCR this will send real funds
      it 'returns result with Binance ID' do
        result = subject.withdraw(
          coin: 'ETH', address: '0xc457d6aD7A4B07839D7eD33C9a043eF4c34eEe4C', amount: '0.09'
        )
        expect(result.value).to include(:id)
      end
    end

    context 'when invalid params' do
      it_behaves_like 'correctly handles invalid api response', :withdraw
    end
  end

  describe '.withdraw_history' do
    context 'when valid params' do
      it 'returns results array with expected keys' do
        result = subject.withdraw_history
        expect(result.value[0]).to include(:id, :amount, :address, :coin, :network, :status, :txId)
      end
    end

    context 'when invalid params' do
      it_behaves_like 'correctly handles invalid api response', :withdraw_history
    end
  end

  describe '.coins_config' do
    context 'when valid params' do
      it 'returns results array with expected keys' do
        result = subject.coins_config
        expect(result.value.first.keys).to include(
          :coin, :depositAllEnable, :withdrawAllEnable, :name, :free, :locked, :freeze,
          :withdrawing, :ipoing, :ipoable, :storage, :isLegalMoney, :trading, :networkList
        )
      end
    end

    context 'when invalid params' do
      it_behaves_like 'correctly handles invalid api response', :coins_config
    end
  end
end
