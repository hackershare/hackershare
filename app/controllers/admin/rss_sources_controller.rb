# frozen_string_literal: true

class Admin::RssSourcesController < Admin::ApplicationController
  before_action :set_rss_source, only: %i[edit update destroy display undisplay]

  def index
    @pagy, @rss_sources = pagy_countless(
      RssSource.order(id: :desc),
      items: 20
    )
  end

  def new
    @rss_source = RssSource.new
  end

  def create
    @rss_source = RssSource.new(rss_source_params)
    if @rss_source.update(creator: current_user)
      flash[:success] = "Created successfully"
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @rss_source.update(rss_source_params)
      flash[:success] = "Updated successfully"
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    if @rss_source.destroy
      flash[:success] = "Destroyed successfully"
    else
      flash[:error] = "Destroyed failed: #{@rss_source.short_error_message}"
    end
    redirect_to action: :index
  end

  def display
    if @rss_source.update(is_display: true)
      @rss_source.tag.bookmarks.rss.update_all(is_display: true) if @rss_source.tag
      flash[:success] = "Displayed successfully"
    else
      flash[:error] = "Displayed failed: #{@rss_source.short_error_message}"
    end
    redirect_to action: :index
  end

  def undisplay
    if @rss_source.update(is_display: false)
      @rss_source.tag.bookmarks.rss.update_all(is_display: false) if @rss_source.tag
      flash[:success] = "Undisplayed successfully"
    else
      flash[:error] = "Undisplayed failed: #{@rss_source.short_error_message}"
    end
    redirect_to action: :index
  end

  private

  def set_rss_source
    @rss_source = RssSource.find(params[:id])
  end

  def rss_source_params
    params.require(:rss_source).permit(:url, :tag_name, :is_display)
  end
end
