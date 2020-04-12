class ProbeSetting < ApplicationRecord
  belongs_to :user
  has_many :rss_probe_histories
  has_many :rss_probe_failure_histories
end
