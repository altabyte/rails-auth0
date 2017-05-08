require 'rails_helper'
require 'shared/redirect_not_authenticated'

RSpec.describe UserProfileController, type: :controller do

  include_context 'redirect edit not authenticated'

  describe 'GET #edit' do
    before { assign_session_for_auth0 }

    it 'returns http success' do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

end
