class RssFeedPresenter < BasePresenter
  presents :rss_feed

  def rss_feed
    @locals[:page] ||= 1
    @locals[:per] ||= 100

    rss_list =     RssFeed.rss_feeds_list(@locals[:user_id], @locals[:rss], @locals[:page], @locals[:per]).map do |rss|
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
      current_page: @locals[:page].to_i,
                total_page: RssFeed.rss_feeds_list(@locals[:user_id], @locals[:rss]).size / @locals[:per].to_i + ((rss_list.size % @locals[:per].to_i == 0) ? 0 : 1),
                rss_list: rss_list
    }

  end
end