require 'rails_helper'

RSpec.describe 'RssPresenter' do
  before(:all) do
    user = FactoryBot.build(:user)
    probe_setting = FactoryBot.build(:probe_setting)
    @presenter = RssPresenter.new(probe_setting, { user: user }, ActionController::Base.new.view_context)
  end

  # it 'returns valid data' do
  #   expect(@presenter.rss.fetch(:probe_settings_id)).to be Integer
  #   expect(@presenter.rss.fetch(:rss)).to be String
  #   expect(@presenter.rss.fetch(:port)).to be Integer
  #   expect(@presenter.rss.fetch(:proxy)).to be String
  #   expect(@presenter.rss.fetch(:retry_limit)).to be Integer
  #   expect(@presenter.rss.fetch(:latest_updated)).to be Time
  #   expect(@presenter.rss.fetch(:status)).to be Boolean
  #   expect(@presenter.rss.fetch(:jid)).to be String
  #   expect(@presenter.rss.fetch(:detail)).to be String
  #   expect(@presenter.rss.fetch(:title)).to be String
  #   expect(@presenter.rss.fetch(:description)).to be String
  #   expect(@presenter.rss.fetch(:unread_count)).to be Integer
  # end
  #
  # it 'returns correct params' do
  #   expect(@presenter.rss.keys).to eq([:probe_settings_id, :rss,
  #                                      :port, :proxy, :retry_limit,
  #                                      :latest_updated, :status, :jid,
  #                                      :detail, :title, :description, :unread_count])
  # end
end