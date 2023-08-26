require 'rails_helper'

RSpec.describe 'JobsManagement/JobsManagementController', type: :routing do
  describe 'routing' do
    it 'routes to #running_jobs_count' do
      expect(get: "/running_jobs_count").to route_to("jobs_management/jobs_management#running_jobs_count")
    end

    it 'routes to #delete_job' do
      expect(delete: "/delete_job").to route_to("jobs_management/jobs_management#delete_job")
    end

    it 'routes to #start_job' do
      expect(post: "/start_job").to route_to("jobs_management/jobs_management#start_job")
    end

    it 'routes to #start_all_jobs' do
      expect(post: "/start_all_jobs").to route_to("jobs_management/jobs_management#start_all_jobs")
    end
  end
end