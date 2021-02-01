class ApplicationController < ActionController::Base
    helper_method :current_user
    #This protect from cancancan assertion and prints the acces violation
    #error on index of session
    protect_from_forgery
      rescue_from CanCan::AccessDenied do |exception|
        flash[:notice] = exception.message
        redirect_to root_url
      end
  
    def current_user
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      else
        @current_user = nil
      end
    end
  end