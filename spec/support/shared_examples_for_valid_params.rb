require 'spec_helper'

RSpec.shared_examples 'valid params' do |method_name, valid_params, response_keys|
  let(:result) do
    if valid_params&.any?
      subject.send(method_name, valid_params)
    else
      subject.send(method_name)
    end
  end
  let(:given_body) { result.value }
  let(:given_response_keys) do
    if given_body.is_a?(Array)
      given_body&.first&.keys || []
    else
      given_body.keys
    end
  end

  it 'response success' do
    expect(result).to be_success
  end

  it 'returns body' do
    expect(given_response_keys).to include(*response_keys)
  end
end
