# frozen_string_literal: true
class RssFeedsController < ApplicationController

  # for web
  def rss_feeds_of_rss
    respond_to do |format|
      format.json
    end
  end

  def mark_readed
    rst = UserRssFeedShip.where(user_id: params[:user_id], unread: true)
    rst = (params['rss_feed_id'].nil?) ? rst : rst.where(rss_feed_id: params['rss_feed_id'])
    rst.update(unread: false)
    render json: {message: "marked #{rst.size} rss feeds"}
  end

  def unread_count
    rst = UserRssFeedShip.where(user_id: params[:id], unread: true).count
    render json: {unread_count: rst}
  end

  def load_more_rss_feed
    respond_to do |format|
      format.json
      format.html { render 'rss_feeds/load_more_rss_feed.json' }
    end
  end
end
