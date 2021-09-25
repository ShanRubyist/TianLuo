class RssPresenter < BasePresenter
  presents :rss

  def rss
    ProbeSetting.rss_list(@locals[:user_id], @locals[:page], @locals[:per]).map do |rss|
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
  end
end
