require 'rails_helper'

RSpec.describe RssQueueJob, type: :job do
  describe '#perform later' do
    it 'enqueued rss feed work jobs' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        RssQueueJob.perform_later
      }.to have_enqueued_job
    end

    it "matches with performed job" do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      expect {
        RssQueueJob.perform_later
      }.to have_performed_job(RssQueueJob)
    end
  end
end
