class ApplicationController < ActionController::Base
    helper_method :current_user
    #This protect from cancancan assertion and prints the acces violation
    #error on index of session
    protect_from_forgery
      rescue_from CanCan::AccessDenied do |exception|
        flash[:notice] = exception.message
        render "layouts/fbi"
      end
  
    def new
      @user = User.new
    end
    def current_user
      if session[:user_id]
        cookies[:id] = session[:user_id]
        @current_user ||= User.find(session[:user_id])
      else
        @current_user = nil
      end
    end
    def ajax
      if session[:user_id]
        data = $new_article
        viewed = session[:notified_new_article]
        if data && data.user_id != params[:id].to_i
          if viewed != data.id || viewed != nil
            session[:notified_new_article] = $new_article.id
            render json: {name: data.title, html: '<a href="articles/'+ data.id.to_s + '">Read More</a>'}
          end
        else
          render json: {}
        end
      end
    end
  end