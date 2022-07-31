class UpdateUserUnreadCountJob < ApplicationJob
  queue_as :default

  # rescue_from(StandardError) do |exp|
  # end

  def perform(args)
    args[:page] ||= 1
    args[:per_page] ||= 10
    total_unread_count = UserRssFeedShip.where(user_id: args[:user_id], unread: true).count

    rss_list = ProbeSetting.rss_list(args[:user_id], args[:page], args[:per]).map do |rss|
      ri = RssInfo.find_by_probe_setting_id(rss.id)
      rss_detail = ProbeSetting.find_by_id(rss.id)
      # rph = RssProbeHistory.find_by_probe_setting_id(rss.id)
      {
        probe_settings_id: rss.id,
        rss: rss_detail.url,
        port: rss_detail.port,
        proxy: rss_detail.proxy,
        retry_limit: rss_detail.retry_limit,
        latest_updated: rss.rss_probe_histories.last&.last_build_date,
        status: rss.rss_probe_histories.last&.status,
        jid: rss.rss_probe_histories.last&.jid,
        detail: rss.rss_probe_histories.last&.detail,
        title: ri&.title || ProbeSetting.find(rss.id).url,
        dscription: ri&.description,
        unread_count: rss.unread_count
      }
    end

    rst = {
      total_unread_count: total_unread_count,
      rss_list: rss_list
    }

    ActionCable.server.broadcast "tl_channel", info: rst
  end
end
