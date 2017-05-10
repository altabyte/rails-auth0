require 'rails_helper'
require 'support/user_not_signed_in_contexts'

RSpec.describe UserProfileController, type: :controller do

  describe 'GET #edit' do

    context 'not signed in' do
      before { get :edit }
      include_context 'user not signed in'
    end

    context 'user signed in' do

      before do
        assign_session_for_auth0
        get :edit
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
