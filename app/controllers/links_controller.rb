class LinksController < ApplicationController
  before_filter :authorize

  def index
    @link = Link.new
    @links = current_user.links
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      flash[:success] = "#{@link.title} saved!"
    else
      flash[:warning] = "Unable to add link."
    end

    redirect_to links_path
  end

private

  def link_params
    params.require(:link).permit(:url, :title)
  end
end
