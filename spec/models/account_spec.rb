require 'rails_helper'

RSpec.describe Account, type: :model do

  describe 'Name' do
    context 'nil' do
      subject(:organization) { FactoryGirl.build(:account, name: nil) }
      it { is_expected.to have(1).errors_on(:name) }
    end

    context 'blank' do
      subject(:organization) { FactoryGirl.build(:account, name: '   ') }
      it { is_expected.to have(1).errors_on(:name) }
    end

    context 'valid' do
      subject(:organization) { FactoryGirl.build(:account, name: '  My   <b>Account</b>     ') }
      it { expect(organization.name).to eq 'My Account' }
    end
  end
end
