class ProbeSetting < ApplicationRecord
  belongs_to :user
  has_many :rss_probe_histories
end
