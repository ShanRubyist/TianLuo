class ProbeSettingPresenter < BasePresenter
  presents :probe_setting

  # def rss
  #   @all_rss_list = ProbeSetting.rss_list(@locals.id)

  #   @all_rss_list_json = []

  #   @all_rss_list.each do |rss_id|
  #     rss = ProbeSetting.find_by_id(rss_id)

  #     @all_rss_list_json << {
  #         probe_settings_id: rss.id,
  #         rss: rss.url,
  #         port: rss.port,
  #         proxy: rss.proxy,
  #         retry_limit: rss.retry_limit,
  #         latest_updated: rss.rss_probe_histories.last&.last_build_date,
  #         status: rss.rss_probe_histories.last&.status,
  #         jid: rss.rss_probe_histories.last&.jid,
  #         detail: rss.rss_probe_histories.last&.detail
  #     }
  #   end
  #   @all_rss_list_json.to_json
  # end
end