require 'rails_helper'

RSpec.describe WebSpiderQueueJob, type: :job do
  describe ' # perform later' do
    it 'enqueued web spider work jobs' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        WebSpiderQueueJob.perform_later
      }.to have_enqueued_job
    end

    it "matches with performed job" do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      expect {
        WebSpiderQueueJob.perform_later
      }.to have_performed_job(WebSpiderQueueJob)
    end
  end
end
