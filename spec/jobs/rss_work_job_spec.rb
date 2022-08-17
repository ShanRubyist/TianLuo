require 'rails_helper'

RSpec.describe RssWorkJob, type: :job do
  describe ' # perform later' do
    let(:probe_setting) { FactoryBot.create(:probe_setting) }

    it 'enqueued web spider work jobs' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        RssWorkJob.perform_later(probe_setting)
      }.to have_enqueued_job
    end

    it "matches with performed job" do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      expect {
        RssWorkJob.perform_later(probe_setting)
      }.to have_performed_job(RssWorkJob)
    end

    # it 'should have enqueued UpdateUserRssJob jobs' do
    #   ActiveJob::Base.queue_adapter = :test
    #   ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    #   expect {
    #     RssWorkJob.perform_later(probe_setting)
    #   }.to have_enqueued_job(UpdateUserRssJob)
    # end

    it "should have rss feeds" do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      RssWorkJob.perform_later(probe_setting)
      expect(RssFeed.count).not_to eq 0
    end
  end
end
