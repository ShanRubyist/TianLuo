# json.array! RssFeed.rss_feeds_list(params[:user_id], params[:rss], params[:page], params[:per]) do |rss|
#   json.id rss.id
#   json.title rss.title
#   json.description rss.description.to_s
#   json.pub_date rss.pub_date.nil? ? '' : rss.pub_date.localtime.strftime('%Y-%m-%d %H:%M')
#   json.author rss.author
#   json.link rss.link
#   json.rss rss.rss_probe_history.title
#   json.rss_link rss.rss_probe_history.link
#   json.rss_description rss.rss_probe_history.description
#   json.status rss.user_rss_feed_ships.first.unread
#   json.thumbs_up rss.user_rss_feed_ships.first.thumbs_up
#   json.tags rss.tags.map { |tag| "#{tag.name}(#{rss.rss_feed_tag_ships.find_by(tag: tag).tf_idf})"}
# end

json.array! (
                present('RssFeedPresenter',
                        user_id: current_user,
                        rss: params[:rss],
                        page: params[:page],
                        per: params[:per])
                    .rss_feed
            )
