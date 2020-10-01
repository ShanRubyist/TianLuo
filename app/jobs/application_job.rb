class ApplicationJob < ActiveJob::Base
  around_enqueue :log_enqueue_status
  around_perform :log_perform_status

  def log_enqueue_status
    if self.arguments.first
      if self.arguments.first.class.to_s == 'ProbeSetting'
        RssProbeHistory.create_with({
                                        probe_setting_id: self.arguments.first.id,
                                        status: 'enqueue',
                                        last_build_date: Time.now
                                    })
            .find_or_create_by(jid: self.job_id)
      elsif self.arguments.class.to_s == 'WebSpiderWorkJob'
        GoodsRefreshHistory.create_with({
                                            pdd_web_spider_setting_id: self.arguments.first.id,
                                            status: 'enqueue',
                                            last_updated_date: Time.now
                                        })
            .find_or_create_by(jid: self.job_id)
      end
    end

    yield

    if self.arguments.first
      if self.arguments.first.class.to_s == 'ProbeSetting'
        RssProbeHistory
            .find_or_create_by(probe_setting_id: self.arguments.first.id, jid: self.job_id)
            .update({ status: 'enqueued' })
      elsif self.arguments.class.to_s == 'WebSpiderWorkJob'
        GoodsRefreshHistory
            .find_or_create_by(pdd_web_spider_setting_id: self.arguments.first.id, jid: self.job_id)
            .update({ status: 'enqueued' })
      end
    end
  end

  def log_perform_status
    Rails.logger.error "before perform"
    Rails.logger.error self.inspect

    if self.arguments.first

      if self.arguments.first.class.to_s == 'ProbeSetting'
        RssProbeHistory
            .find_or_create_by(probe_setting_id: self.arguments.first.id, jid: self.job_id)
            .update({ status: 'performing' })
      elsif self.arguments.class.to_s == 'WebSpiderWorkJob'
        GoodsRefreshHistory
            .find_or_create_by(pdd_web_spider_setting_id: self.arguments.first.id, jid: self.job_id)
            .update({ status: 'performing' })
      end
    end

    yield

    if self.arguments.first

      if self.arguments.first.class.to_s == 'ProbeSetting'
        RssProbeHistory
            .find_or_create_by(probe_setting_id: self.arguments.first.id, jid: self.job_id)
            .update({ status: 'success' })
      elsif self.arguments.class.to_s == 'WebSpiderWorkJob'
        GoodsRefreshHistory
            .find_or_create_by(pdd_web_spider_setting_id: self.arguments.first.id, jid: self.job_id)
            .update({ status: 'success' })
      end
    end
  end
end
