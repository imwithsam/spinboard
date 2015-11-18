class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.email_address}!"
      redirect_to links_path
    else
      flash.now[:warning] = "Unable to log in."
      render action: "new"
    end
  end
end
