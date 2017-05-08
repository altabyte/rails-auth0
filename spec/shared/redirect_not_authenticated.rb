require 'rails_helper'

shared_context 'redirect index not authenticated' do

  describe 'GET #index' do
    it 'redirects to login page' do
      get :index

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(login_path)
    end
  end
end

shared_context 'redirect edit not authenticated' do

  describe 'GET #edit' do
    it 'redirects to login page' do
      get :edit

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(login_path)
    end
  end
end
