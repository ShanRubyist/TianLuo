class RssFeedsController < ApplicationController
  include RSSConcern

  def mark_readed
    UserRssFeedShip.where(user_id: params[:user_id])
        .update(unread: false)
  end

  def load_more_rss_feed
    rss_list = rss_list(params['user_id'], params['page'], params['per'])

    rss_list_json = rss_list.map do |rss|
      {
          title: rss.title,
          description: rss.description,
          pub_date: rss.pub_date.nil? ? '' : rss.pub_date.localtime.strftime("%Y-%m-%d %H:%M"),
          author: rss.author,
          link: rss.link,
          rss: rss.rss_probe_history.title,
          rss_link: rss.rss_probe_history.link,
          rss_description: rss.rss_probe_history.description,
          status: rss.user_rss_feed_ship.first.unread
      }
    end

    render :json => rss_list_json
  end

end
