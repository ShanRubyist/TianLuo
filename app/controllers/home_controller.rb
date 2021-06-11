# frozen_string_literal: true

class HomeController < ApplicationController
  include RssReadable
  include GoodsReadable
  include RSSList

  def index
    @rss_feeds_list = rss_feeds_list
    @goods_list = goods_list(params['page'], params['per'])

    @unread_count = UserRssFeedShip.where(user_id: current_user.id, unread: true).count

    per ||= 200
    params['page'] ||= 1

    @all_rss_list = rss_list

    @all_rss_list_json = []

    @all_rss_list.each do |rss|
      ri = RssInfo.find_by_probe_setting_id(rss.id)
      # rph = RssProbeHistory.find_by_probe_setting_id(rss.id)
      @all_rss_list_json << {
          probe_settings_id: rss.id,
          # rss: rss.url,
          # port: rss.port,
          # proxy: rss.proxy,
          # retry_limit: rss.retry_limit,
          # latest_updated: rss.last_build_date,
          # status: rss.refresh_status,
          # jid: rss.jid,
          # detail: rss.detail,
          title: ri&.title || ProbeSetting.find(rss.id).url,
          dscription: ri&.description,
          unread_count: rss.unread_count
      }
    end

    render_view_for_device '/home/index'
  end
end
