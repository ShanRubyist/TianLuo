class RssFeedPresenter < BasePresenter
  presents :rss_feed

  def rss_feed
    @locals[:page] ||= 1
    @locals[:per] ||= 100

    user_rss_feeds = RssFeed
                       .includes(:user_rss_feed_ships)
                       .where(user_rss_feed_ships: { user_id: @locals[:user_id] })

    user_rss_feeds_of_current_rss = @locals[:rss] ? user_rss_feeds.where(probe_setting: @locals[:rss]) : user_rss_feeds

    rss_feed_list =  RssFeed.rss_feeds_list(@locals[:user_id], @locals[:rss], @locals[:page], @locals[:per]).map do |rss|
      {
        id: rss.id,
        title: rss.title,
        description: Loofah.fragment(rss.description).scrub!(:escape).to_html,
        pub_date: rss.pub_date.nil? ? '' : rss.pub_date.localtime.strftime("%Y-%m-%d %H:%M"),
        author: rss.author,
        enclosure: rss.enclosure,
        link: rss.link,
        rss: rss.probe_setting&.rss_info&.title,
        rss_link: rss.probe_setting&.rss_info&.link,
        rss_description: rss.probe_setting&.rss_info&.description,
        icon: rss.probe_setting&.rss_info&.icon,
        status: !rss.user_rss_feed_ships.first&.unread,
        thumbs_up: rss.user_rss_feed_ships.first&.thumbs_up,
        tags: rss.tags.map do |tag|
          {
            name: tag.name,
            tf_idf: rss.rss_feed_tag_ships.find_by(tag: tag).tf_idf,
            recommend: ''
          }
        end
      }
    end

    {
      current_rss: @locals[:rss],
      current_page: @locals[:page].to_i,
      total_num: user_rss_feeds.count,
      total_unread_count: user_rss_feeds.where(user_rss_feed_ships: { unread: true }).count,
      total_num_of_current_rss: user_rss_feeds_of_current_rss.count,
      total_unread_count_of_current_rss: user_rss_feeds_of_current_rss.where(user_rss_feed_ships: { unread: true }).count,
      rss_feed_list: rss_feed_list
    }

  end
end