require 'rails_helper'

RSpec.describe Histories::HistoriesController, type: :controller do
  login_user

  before do
    @probe_setting = FactoryBot.create(:probe_setting)
    @rss_probe_history = FactoryBot.create(:rss_probe_history, probe_setting: @probe_setting)
  end

  describe 'GET #histories' do
    it 'proxy to rss histories' do
      spy_controller = spy(controller)
      get :histories, params: { type: 'unkown', setting_id: 1 }
      # expect(spy_controller).to have_received(:rss_histories)
      expect(response.body).to eq '[]'
    end

    it 'get rss histories with type 0' do
      get :histories, params: { type: 0, setting_id: @probe_setting.id }
      expect(response.body).to match /#{@rss_probe_history.id}/
    end
  end
end
