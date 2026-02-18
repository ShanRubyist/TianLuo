# frozen_string_literal: true
class RssFeedsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:daily]

  # for web
  def index
    respond_to do |format|
      format.json
    end
  end

  def briefly_info
    user_rss_feeds = RssFeed
                       .includes(:user_rss_feed_ships)
                       .where(user_rss_feed_ships: { user_id: current_user.id })

    user_rss_feeds_of_current_rss = params[:rss] ? user_rss_feeds.where(probe_setting: params[:rss]) : user_rss_feeds

    render json: {
      total_num_of_current_rss: user_rss_feeds_of_current_rss.count,
      total_unread_count_of_current_rss: user_rss_feeds_of_current_rss.where(user_rss_feed_ships: { unread: true }).count
    }
  end

  def recommend
    respond_to do |format|
      format.json
    end
  end

  def favor
    respond_to do |format|
      format.json
    end
  end

  def recommend_feeds_of_specify_feed
    respond_to do |format|
      format.json
    end
  end

  def toggle_thumbs_up
    rst = UserRssFeedShip.find_by(user_id: params[:user_id], rss_feed_id: params['rss_feed_id'])
    rst.update(thumbs_up: !rst.thumbs_up)
    render json: {message: (rst.reload.thumbs_up ? "已点赞" : "取消点赞")}
  end

  def mark_all_as_read
    rst = UserRssFeedShip.where(user_id: params[:user_id], unread: true)
    rst = (params['rss_feed_id'].nil?) ? rst : rst.where(rss_feed_id: params['rss_feed_id'])
    rst.update(unread: false)

    UpdateUserRssJob.perform_now(user_id: params[:user_id])

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

  def daily
    @rss_feeds = RssFeed.where('DATE(created_at) = ?', Date.current).order(created_at: :desc)

    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
