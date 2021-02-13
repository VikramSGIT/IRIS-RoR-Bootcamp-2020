class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:private_access] = user.private_access
      redirect_to root_url, notice: 'Logged in!'
    else
      flash[:alert] = 'Email or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:private_access] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end