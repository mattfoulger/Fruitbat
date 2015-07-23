class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end

  def restrict_admin_access
    unless admin?
      flash[:alert] = "You are not an administrator."
      redirect_to root_path
    end
  end

  def admin?
    current_user && current_user.admin
  end

  def impersonating?
    session[:previous_id]
  end

  helper_method :current_user
  helper_method :restrict_admin_access
  helper_method :admin?
  helper_method :impersonating?


end
