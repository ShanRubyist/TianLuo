FactoryBot.define do
  factory :pdd_web_spider_setting do
    association :user
    url { 'http://mobile.yangkeduo.com/goods.html?goods_id=88069366847'}
    port { 80 }
    retry_limit { 3 }
    proxy {}
    cookies { '' }
    log_path {}
    status { true }
  end

  factory :invalid_pdd_web_spider_setting, class: PddWebSpiderSetting do
    association :user
    port { 80 }
    retry_limit { 3 }
    proxy {}
    cookies { '' }
    log_path {}
    status { true }
  end
end