class HomePresenter < BasePresenter
  presents :home

  def all_rss_list_json
    @all_rss_list = ProbeSetting.rss_list(@locals.id)

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
    @all_rss_list_json.to_json
  end

  def rss_feeds_list
    rst = []
    RssFeed.rss_feeds_list(@locals.id).each do |rss|
      rst << {
          title: rss.title,
          description: Loofah.fragment(rss.description).scrub!(:escape).to_html,
          pub_date: rss.pub_date.nil? ? '' : rss.pub_date.localtime.strftime("%Y-%m-%d %H:%M"),
          author: rss.author,
          link: rss.link,
          rss: rss.probe_setting.rss_info.title,
          rss_link: rss.probe_setting.rss_info.link,
          rss_description: rss.probe_setting.rss_info.description,
          icon: rss.probe_setting.rss_info.icon,
          status: !rss.user_rss_feed_ships.first.unread,
          tags: rss.tags.map { |tag| "#{tag.name}(#{rss.rss_feed_tag_ships.find_by(tag: tag).tf_idf})"}
      }
    end
    rst.to_json
  end

  def goods_list
    Good.goods_list(current_user.id, params['page'], params['per'])
  end

  def unread_count
    UserRssFeedShip.where(user_id: current_user.id, unread: true).count
  end
end