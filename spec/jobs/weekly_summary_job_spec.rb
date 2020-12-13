require 'rails_helper'

RSpec.describe WeeklySummaryJob, type: :job do
  describe ' # perform later' do
    it 'enqueued weekly summary jobs' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        WeeklySummaryJob.perform_later
      }.to have_enqueued_job.on_queue(:default)
    end

    it "matches with performed job" do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      expect {
        WeeklySummaryJob.perform_later
      }.to have_performed_job(WeeklySummaryJob)
    end
  end

end
