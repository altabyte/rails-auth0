require 'rails_helper'
require 'shared/redirect_not_authenticated'

RSpec.describe DashboardController, type: :controller do

  include_context 'redirect index not authenticated'

  describe 'GET #index' do
    before { assign_session_for_auth0 }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
