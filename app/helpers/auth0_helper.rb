module Auth0Helper

  def authenticated?
    session[:userinfo].present?
  end

end
