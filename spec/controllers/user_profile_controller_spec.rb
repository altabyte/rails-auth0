require 'rails_helper'

RSpec.describe UserProfileController, type: :controller do

  context 'Not authenticated' do
    it 'returns http success' do
      get :edit
      expect(response).to redirect_to login_path
    end
  end


  describe 'GET #edit' do
    before { assign_session_for_auth0 }

    it 'returns http success' do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

end
