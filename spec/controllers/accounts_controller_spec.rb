require 'rails_helper'
require 'support/user_not_signed_in_contexts'

RSpec.describe AccountsController, type: :controller do

  describe 'GET #index' do

    context 'not signed in' do
      before { get :index }
      include_context 'user not signed in'
    end

    context 'user signed in' do
      before do
        assign_session_for_auth0 user: user
        get :index
      end

      context 'not super admin' do
        let(:user) { create_user }

        it 'redirects to dashboard' do
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(dashboard_path)
        end
      end

      context 'super admin' do
        let(:user) { create_user app_metadata: { super_admin: true } }

        it 'redirects to dashboard' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
