require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  context 'Not authenticated' do
    it 'returns http success' do
      get :index
      expect(response).to redirect_to root_path
    end
  end


  describe 'GET #index' do
    before { assign_session_for_auth0 }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
