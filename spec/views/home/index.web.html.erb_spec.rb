require 'rails_helper'

RSpec.describe 'home/index', type: :view do
  before do
    @user = User.create!(FactoryBot.attributes_for(:user))
    @rss_feed = FactoryBot.create(:rss_feed1)
  end

  it '显示首页' do
    # assign(:rss_list, {})
    #
    # render
    # expect(rendered).to match(/abc/)
  end

  it '渲染 index.web.html.erb 模板' do
    allow(controller).to receive(:current_user).and_return(@user)
    allow(@rss_feeds_list).to receive(:first).and_return(@rss_feed)

    render template: 'home/index.web.html.erb'
    expect(rendered.match(/sidebar/)).not_to eq nil
  end
end