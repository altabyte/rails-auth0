require 'rails_helper'

shared_context 'user not signed in' do |_| # Can pass parameters through block

  it { expect(response).to have_http_status(302) }
  it { expect(response).to redirect_to(login_path) }

end
