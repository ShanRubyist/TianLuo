class WebSpiderFailureHistory < ApplicationRecord
  belongs_to :pdd_web_spider_setting

  def self.store_fail_spider_to_db(setting_id, reason, detail)
    create(
        pdd_web_spider_setting_id: setting_id,
        status: 'Failure',
        reason: reason,
        detail: detail)
  end
end
