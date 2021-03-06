FactoryBot.define do
  factory :probe_setting do
    association :user
    url { 'https://ruby-china.org/topics/feed'}
    port { 80 }
    retry_limit { 3 }
    proxy {}
    log_path {}
    status { true }
  end

  factory :invalid_probe_setting, class: ProbeSetting do
    association :user
    port { 80 }
    retry_limit { 3 }
    proxy {}
    log_path {}
    status { true }
  end
end