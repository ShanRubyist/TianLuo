class UpdateUserRssFeedJob < ApplicationJob
  queue_as :default

  def perform(args)
    args[:page] ||= 1
    args[:per_page] ||= 10

    rss_feed_list =   RssFeed.rss_feeds_list(args[:user_id], args[:rss]).map do |rss|
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


    rst = {
      type: 'tl_update_status',
      rss_feed_list: rss_feed_list
    }

    ActionCable.server.broadcast "tl_#{args[:user_id]}_channel", info: rst
  end
end
