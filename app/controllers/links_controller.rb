class LinksController < ApplicationController
  before_filter :authorize

  def index
    @link = Link.new
    # @links = current_user.links

    @filterrific = initialize_filterrific(
      Link,
      params[:filterrific],
      select_options: {
        sorted_by: Link.options_for_sorted_by,
        read_status: Link.options_for_read_status
      },
      persistence_id: 'shared_key',
      default_filter_params: { sorted_by: 'created_at_desc' },
      available_filters: [
        :sorted_by,
        :read_status,
        :search_query
      ]
    ) or return

    @links = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end

  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
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

  def edit
    @link = current_user.links.find(params[:id])
  end

  def update
    @link = current_user.links.find(params[:id])

    if @link && @link.update(link_params)
      flash[:success] = "#{@link.title} updated!"
      respond_to do |format|
        format.html { redirect_to links_path }
        format.json { render json: @link }
      end
    else
      flash[:warning] = "Unable to update link."
      respond_to do |format|
        format.html { redirect_to links_path }
        format.json { render json: { success: false } }
      end
    end
  end

private

  def link_params
    params.require(:link).permit(:url, :title, :read)
  end
end
