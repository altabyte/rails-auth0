require 'rails_helper'
require 'auth0/user'

shared_context 'permit super admin' do

  let(:true_values) { [true, 1, 'YES'] }

  it 'permits super admin' do
    true_values.each do |value|
      expect(subject).to permit(create_user(app_metadata: { super_admin: value }), account)
    end
  end
end

shared_context 'deny access unless super admin' do
  include_context 'permit super admin'

  let(:false_values) { [false, 0, 'NO', :random_value] }

  it 'denies access if super admin role is not true' do
    false_values.each do |value|
      expect(subject).not_to permit(create_user(app_metadata: { super_admin: value }), account)
    end
  end

  it 'denies access if super_admin role not defined' do
    expect(subject).not_to permit(create_user, account)
  end
end

RSpec.describe AccountPolicy do

  subject { described_class }
  let(:account) { FactoryGirl.create(:account) }

  permissions '.scope' do
  end

  permissions :index?, :new?, :create?, :destroy? do
    include_context 'deny access unless super admin'
  end

  permissions :show?, :edit?, :update? do
    include_context 'permit super admin'

    context 'user is a member of this account' do
      let(:user) { create_user(app_metadata: { account_ids: [account.id] }) }

      it { expect(subject).to permit(user, account) }
    end
  end

end
