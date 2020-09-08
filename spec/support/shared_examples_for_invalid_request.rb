require 'spec_helper'

RSpec.shared_examples 'correctly handles invalid api response' do |method_name|
  it 'throws BinanceAPI::RequestError' do
    expect { subject.send(method_name, coin: 'MYCOIN') }.to(
      raise_error(BinanceAPI::RequestError)
    )
  end

  it 'throws exception with error message' do
    subject.send(method_name, coin: 'MYCOIN')
  rescue => e
    expect(e.message).to include('Invalid API-key, IP, or permissions for action')
  end

  it 'throws exception with status code' do
    subject.send(method_name, coin: 'MYCOIN')
  rescue => e
    expect(e.status).to eq(400)
  end
end
