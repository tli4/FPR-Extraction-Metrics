class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :save_return_to

  before_action :authenticate_user!

  def save_return_to
    if params[:return_to].present?
      session[:return_to] = params[:return_to]
      params.delete(:return_to)
    end
  end

  def return_to_or_redirect_to(options)
    if session[:return_to]
      redirect_to session[:return_to]
      session.delete(:return_to)
    else
      redirect_to options
    end
  end

  def after_sign_up_path_for(user)
      sign_out user
  end
end
