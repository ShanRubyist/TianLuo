require 'rails_helper'

RSpec.describe UpdateUserRssJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_later' do
    it 'enqueued update user rss job' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        UpdateUserRssJob.perform_later(user_id: user.id)
      }.to have_enqueued_job.on_queue('update_job')
    end

    it 'matches with performed job' do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      expect {
        UpdateUserRssJob.perform_later(user_id: user.id)
      }.to have_performed_job(UpdateUserRssJob).on_queue('update_job')
    end
  end
end
