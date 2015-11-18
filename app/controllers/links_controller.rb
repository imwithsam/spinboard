class LinksController < ApplicationController
  before_filter :authorize

  def index
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    @links = Link.all

    if @link.save
      flash.now[:success] = "#{@link.title} saved!"
      @link = Link.new
      render action: "index"
    else
      @link = Link.new
      flash.now[:warning] = "Unable to add link."
      render action: "index"
    end
  end

private

  def link_params
    params.require(:link).permit(:url, :title)
  end
end
