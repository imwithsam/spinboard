class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)

    if user.save
      flash[:success] = "New account created for #{user.email_address}!"
      redirect_to links_path
    else
      flash[:warning] = "Unable to create account."
      redirect_to root_path
    end
  end

private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
