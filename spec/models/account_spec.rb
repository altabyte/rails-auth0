require 'rails_helper'

RSpec.describe Account, type: :model do

  describe 'Name' do
    context 'nil' do
      subject(:organizataccountion) { FactoryGirl.build(:account, name: nil) }
      it { is_expected.to have(1).errors_on(:name) }
    end

    context 'blank' do
      subject(:account) { FactoryGirl.build(:account, name: '   ') }
      it { is_expected.to have(1).errors_on(:name) }
    end

    context 'valid' do
      subject(:account) { FactoryGirl.build(:account, name: '  My   <b>Account</b>     ') }
      it { expect(account.name).to eq 'My Account' }
    end
  end

  describe 'Settings' do
    context 'not defined' do
      subject(:account) { FactoryGirl.build(:account) }
      it { expect(account.settings).not_to be_nil }
      it { expect(account.settings).to be_a Hash }
      it { expect(account.settings).to be_empty }
    end

    context 'create a setting' do
      subject(:account) { FactoryGirl.build(:account) }

      let(:key) { 'key' }
      let(:value) { 123_456 }
      before do
        account.settings[key] = value
        expect(account.save).to be true
        account.reload
      end

      it { expect(account.settings).not_to be_empty }
      it { expect(account.settings).to have_key(key) }
      it { expect(account.settings.fetch(key, nil)).to eq value }
    end

    # store_accessor
    describe '#theme' do
      subject(:account) { FactoryGirl.build(:account) }

      it { expect(account).to respond_to :theme }

      context 'not set' do
        it { expect(account.theme).to be_nil }
      end

      context 'assigning value' do
        let(:theme) { 'Candy' }
        before do
          account.theme = theme
          expect(account.save).to be true
          account.reload
        end

        it { expect(account.settings).to have_key('theme') }
        it { expect(account.theme).to eq theme }
      end
    end
  end
end
