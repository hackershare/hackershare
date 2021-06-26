# frozen_string_literal: true

class RssSourcesController < ApplicationController
  def create
    @rss_source = RssSource.new(rss_source_params)
    @rss_source.validate
    if @rss_source.errors[:url].any?
      flash[:error] = @rss_source.errors[:url].to_sentence
      redirect_back fallback_location: root_path
      return
    end
    begin
      request_rss_source_tag!
    rescue => e
      logger.error "[RssSourcesController#create]"
      logger.error e.message
      flash[:error] = t("rss_source_invalid")
      redirect_back fallback_location: root_path
      return
    end
    if @rss_source.update(creator: current_user)
      current_user.tag_subscriptions.create!(tag: @rss_source.tag)
      flash[:success] = t("rss_source_add_successfully")
      redirect_to categories_path(subscribed: true)
    else
      flash[:error] = @rss_source.short_error_message
      redirect_back fallback_location: root_path
    end
  end

  private

  def rss_source_params
    params.require(:rss_source).permit(:url)
  end

  def request_rss_source_tag!
    res = http.get(@rss_source.url)
    feed = Feedjira.parse(res.to_s)
    @rss_source.tag_name = feed.title.force_encoding("utf-8")
    tag = Tag.find_by(name: @rss_source.tag_name)
    if tag
      tag.update!(is_rss: true)
      @rss_source.update!(tag: tag)
    else
      @rss_source.create_tag!(is_rss: true, name: @rss_source.tag_name, user: User.rss_robot)
    end
  end

  def http
    @http ||= begin
      proxy = ENV["https_proxy"] || ENV["http_proxy"]
      if proxy
        uri = URI.parse(proxy)
        HTTP.via(uri.host, uri.port)
      else
        HTTP
      end
    end
  end
end
