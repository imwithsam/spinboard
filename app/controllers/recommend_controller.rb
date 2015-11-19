class RecommendController < ApplicationController
  before_action :authorize

  def new
    @link = current_user.links.find(params[:id])

    if @link
      render :new
    else
      flash[:warning] = "Unable to email your recommendation."
      redirect_to :back
    end
  end

  def create
    @link = current_user.links.find(params[:id])
    @email = params[:email_address]

    if @link && @email
      LinkMailer.recommend(@link, @email).deliver_later
      flash[:success] = "Your recommendation has been emailed to #{@email}!"
    else
      flash[:warning] = "Unable to email your recommendation."
    end

    redirect_to links_path
  end

private

  def link_params
    params.require(:link).permit(:url, :title)
  end
end
