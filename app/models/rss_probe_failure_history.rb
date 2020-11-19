class RssProbeFailureHistory < ApplicationRecord
  belongs_to :probe_setting

  # def self.store_fail_rss_to_db(probe_setting_id, reason, detail)
  #   RssProbeFailureHistory.create(
  #       probe_setting_id: probe_setting_id,
  #       status: 'Failure',
  #       reason: reason,
  #       detail: detail)
  # end
end
