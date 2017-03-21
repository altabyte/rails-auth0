require 'rails_helper'

include Auth0RequestSpecHelper

RSpec.describe Auth0Controller, type: :controller do

  describe 'GET #callback' do
    before do

      assign_request_env_for_auth0
    end

    it 'returns http success' do
      get :callback
      expect(response).to redirect_to dashboard_path
    end
  end

  describe 'GET #failure' do
    it 'returns http success' do
      get :failure
      expect(response).to have_http_status(:success)
    end
  end
end
