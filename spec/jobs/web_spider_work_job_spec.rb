require 'rails_helper'

RSpec.describe WebSpiderWorkJob, type: :job do
  describe ' # perform later' do
    let(:web_spider_setting) { FactoryBot.create(:pdd_web_spider_setting) }

    it 'enqueued web spider work jobs' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        WebSpiderWorkJob.perform_later(web_spider_setting)
      }.to have_enqueued_job.with(web_spider_setting).on_queue(:web_spider)
    end

    it "matches with performed job" do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      expect {
        WebSpiderWorkJob.perform_later(web_spider_setting)
      }.to have_performed_job(WebSpiderWorkJob)
    end
  end
end
