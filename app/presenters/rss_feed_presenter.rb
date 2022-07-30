class RssFeedPresenter < BasePresenter
  presents :rss_feed

  def rss_feed
    RssFeed.rss_feeds_list(@locals[:user_id], @locals[:rss], @locals[:page], @locals[:per]).map do |rss|
      {
        id: rss.id,
        title: rss.title,
        description: Loofah.fragment(rss.description).scrub!(:escape).to_html,
        pub_date: rss.pub_date.nil? ? '' : rss.pub_date.localtime.strftime("%Y-%m-%d %H:%M"),
        author: rss.author,
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
  end
end