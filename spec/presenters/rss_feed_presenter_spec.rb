require 'rails_helper'

RSpec.describe 'RssFeedPresenter' do
  before(:all) do
    user = FactoryBot.build(:user)
    @presenter = RssFeedPresenter.new(RssFeed.new, { user: user }, ActionController::Base.new.view_context)
  end

  it 'returns valid data' do
    expect(@presenter.rss_feed.fetch(:current_rss)).to be nil
    expect(@presenter.rss_feed.fetch(:current_page)).to be_a Integer
    expect(@presenter.rss_feed.fetch(:total_num)).to be_a Integer
    expect(@presenter.rss_feed.fetch(:total_num_of_current_rss)).to be_a Integer
    expect(@presenter.rss_feed.fetch(:total_unread_count_of_current_rss)).to be_a Integer
    expect(@presenter.rss_feed.fetch(:rss_feed_list)).to be_a Array
  end

  it 'returns correct params' do
    expect(@presenter.rss_feed.keys.sort).to eq([:current_rss, :current_page, :total_unread_count,
                                            :total_num, :total_num_of_current_rss,
                                            :total_unread_count_of_current_rss, :rss_feed_list].sort)
  end
end