require 'rails_helper'

RSpec.describe PddWebSpiderSetting, type: :model do
  it 'is valid with a url' do
    expect(FactoryBot.build(:pdd_web_spider_setting)).to be_valid
  end

  it 'should respond to url' do
    expect(FactoryBot.build(:pdd_web_spider_setting)).to respond_to(:url)
  end

  it 'is correct url' do
    expect(FactoryBot.build(:pdd_web_spider_setting).url).to eq('http://mobile.yangkeduo.com/goods.html?goods_id=88069366847')
  end
end
