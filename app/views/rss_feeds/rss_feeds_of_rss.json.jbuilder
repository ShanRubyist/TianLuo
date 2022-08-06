# json.array! RssFeed.rss_feeds_list(params[:user_id], params[:rss]) do |rss|
#   json.id rss.id
#   json.title rss.title
#   json.description Loofah.fragment(rss.description).scrub!(:escape).to_html
#   json.pub_date rss.pub_date.nil? ? '' : rss.pub_date.localtime.strftime("%Y-%m-%d %H:%M")
#   json.author rss.author
#   json.link rss.link
#   json.rss rss.probe_setting.rss_info.title
#   json.rss_link rss.probe_setting.rss_info.link
#   json.rss_description rss.probe_setting.rss_info.description
#   json.icon rss.probe_setting.rss_info.icon
#   json.status !rss.user_rss_feed_ships.first.unread
#   json.thumbs_up rss.user_rss_feed_ships.first.thumbs_up
#   json.tags rss.tags.map { |tag| "#{tag.name}(#{rss.rss_feed_tag_ships.find_by(tag: tag).tf_idf})"}
# end

rss_list =          present('RssFeedPresenter',
                        user_id: current_user,
                        rss: params[:rss],
                        page: params[:page],
                        per: params[:per])
                    .rss_feed
                   

json.data rss_list