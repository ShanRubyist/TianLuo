# frozen_string_literal: true

class HomeController < ApplicationController
  include RssReadable
  include GoodsReadable
  include RSSList

  def index
    @rss_feeds_list = RssFeed.rss_feeds_list(current_user.id)
    @goods_list = Good.goods_list(current_user.id, params['page'], params['per'])
    @unread_count = UserRssFeedShip.where(user_id: current_user.id, unread: true).count

    per ||= 200
    params['page'] ||= 1

    render_view_for_device '/home/index'
  end
end
