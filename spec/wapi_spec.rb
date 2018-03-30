RSpec.describe BinanceAPI::WAPI do
  let(:service) { BinanceAPI.wapi }
  context 'Returns a BinanceAPI::Rest' do
    it { expect(service).to be_a_kind_of(BinanceAPI::WAPI) }
  end

  pending "#withdraw spec"

  context '#deposit_history' do
    context 'valid asset' do
      subject { service.deposit_history('ETH') }
      it {
        is_expected.to have_attributes(
          value: {
            success: true,
            depositList: all(
              match(
                insertTime: a_kind_of(Integer),
                amount: a_kind_of(Integer) | a_kind_of(Float),
                asset: 'ETH',
                address: a_kind_of(String),
                txId: a_kind_of(String),
                status: a_kind_of(Integer)
              ) |
                  match(
                    insertTime: a_kind_of(Integer),
                    amount: a_kind_of(Integer) | a_kind_of(Float),
                    asset: 'ETH',
                    address: a_kind_of(String),
                    addressTag: a_kind_of(String),
                    txId: a_kind_of(String),
                    status: a_kind_of(Integer)
                  )
            )
          }
        )
      }
      it { expect(subject.success?).to be_truthy }
    end

    context 'invalid asset' do
      subject { service.deposit_history('x') }
      it { is_expected.to have_attributes(value: { success: true, depositList: be_empty }) }
      it { expect(subject.success?).to be_truthy }
    end
  end

  context '#withdraw_history' do
    context 'valid asset' do
      subject { service.withdraw_history('BTC') }
      it {
        is_expected.to have_attributes(
          value: {
            success: true,
            withdrawList: all(
              match(
                id: a_kind_of(String),
                amount: a_kind_of(Integer) | a_kind_of(Float),
                address: a_kind_of(String),
                successTime: a_kind_of(Integer),
                asset: 'BTC',
                txId: a_kind_of(String),
                applyTime: a_kind_of(Integer),
                status: a_kind_of(Integer)
              ) |
                  match(
                    id: a_kind_of(String),
                    amount: a_kind_of(Integer) | a_kind_of(Float),
                    address: a_kind_of(String),
                    successTime: a_kind_of(Integer),
                    addressTag: a_kind_of(String),
                    asset: 'BTC',
                    txId: a_kind_of(String),
                    applyTime: a_kind_of(Integer),
                    status: a_kind_of(Integer)
                  )
            )
          }
        )
      }
      it { expect(subject.success?).to be_truthy }
    end

    context 'invalid asset' do
      subject { service.withdraw_history('x') }
      it { is_expected.to have_attributes(value: { success: true, withdrawList: be_empty }) }
      it { expect(subject.success?).to be_truthy }
    end
  end

  context '#deposit_address' do
    context 'valid asset' do
      subject { service.deposit_address('ETH') }
      it {
        is_expected.to have_attributes(
          value: {
            success: true,
            address: a_kind_of(String),
            addressTag: a_kind_of(String),
            asset: 'ETH'
          }
        )
      }
      it { expect(subject.success?).to be_truthy }
    end

    context 'invalid asset' do
      subject { service.deposit_address('x') }
      it { is_expected.to have_attributes(value: { success: false }) }
      it { expect(subject.success?).to be_falsey }
    end
  end

  context '#withdraw_fee' do
    context 'valid asset' do
      subject { service.withdraw_fee('ETH') }
      it { is_expected.to have_attributes(value: { success: true, withdrawFee: a_kind_of(Float) }) }
      it { expect(subject.success?).to be_truthy }
    end

    context 'invalid asset' do
      subject { service.withdraw_fee('x') }
      it { is_expected.to have_attributes(value: { success: false, msg: 'The coin does not exist.' }) }
      it { expect(subject.success?).to be_falsey }
    end
  end

  context '#account_status' do
    subject { service.account_status }
    it {
      is_expected.to have_attributes(
        value: {
          success: true,
          msg: a_kind_of(String),
        }
      )
    }
    it { expect(subject.success?).to be_truthy }
  end

  context '#system_status' do
    subject { service.system_status }
    it {
      is_expected.to have_attributes(
        value: {
          status: match(0) | match(1),
          msg: match('normal') | match('system maintenance')
        }
      )
    }
    it { expect(subject.success?).to be_truthy }
  end
end
