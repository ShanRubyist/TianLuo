require 'probe'

class RssWorkJob < ApplicationJob
  queue_as :rss_job

  include JobsCallConcern

  rescue_from(RSSProbe::FetchException) do |exp|
    record_failure(exp)
  end

  rescue_from(RSSProbe::RetryTooManyTimeException) do |exp|
    record_failure(exp)
  end

  rescue_from(StandardError) do |exp|
    # StandardError 会捕获包括 RuntimeError 的异常
    record_failure(exp)
  end

  def record_failure(exp)
    probe_setting = self.arguments.first

    RssProbeFailureHistory.store_fail_rss_to_db(
        probe_setting.id,
        exp.message,
        exp.backtrace.join('<br />')
    )
  end

  def perform(setting)
    call_rss_work_job(setting)
  end
end
