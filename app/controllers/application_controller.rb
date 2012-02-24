class ApplicationController < ActionController::Base
  before_filter :login_from_cookie
  helper_method :current_user, :logged_in?
  
  protected
     
  def current_user
    @current_user ||= Identity.find_by_id(session[:identity])
  end
  
  def current_user=(identity)
    session[:identity] = identity.id
  end
  
  def logged_in?
    !self.current_user.nil?
  end
  
  def login_required
    return true if logged_in?
    flash[:notice] = 'Please login to do this'
    redirect_to login_path
    false
  end   
  
  def login_from_cookie
    return unless cookies[:token] && !logged_in?
    identity = Identity.find_by_token(cookies[:token])
    if identity && identity.token?
      self.current_user = identity
    else
      clear_cookies
    end
  end
  
  def clear_cookies
    cookies.delete :token
  end
end