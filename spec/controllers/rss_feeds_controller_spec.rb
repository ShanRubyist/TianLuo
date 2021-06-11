require 'rails_helper'

RSpec.describe RssFeedsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:probe_setting) { FactoryBot.create(:probe_setting, users: [user]) }
  let(:rss_feed) { FactoryBot.create(:rss_feed1, probe_setting: probe_setting)}

  before do
    rss_feed.users = [user]
    rss_feed.save
  end

  login_user

  describe 'PUT #mark_read' do
    it 'mark all rss feed readed' do
      patch :mark_readed, params: {user_id: user.id}
      expect(response).to have_http_status(:success)
      expect(UserRssFeedShip.where(user: user, unread: true).count).to eq 0
    end

    it 'mark specific rss feed readed' do
      patch :mark_readed, params: {user_id: user.id, rss_feed_id: rss_feed.id}
      expect(response).to have_http_status(:success)
      expect(UserRssFeedShip.find_by(user: user, rss_feed: rss_feed).unread).to eq false
    end
  end

  describe 'GET #load_more_rss_feed' do
    let(:user) { FactoryBot.create(:user) }
    let(:page) { 1 }
    let(:per) { 10 }

    it 'load more rss feed in text/html content type' do
      get :load_more_rss_feed, params: {user_id: user.id, rss: probe_setting, page: page, per: per}
      expect(response.headers['Content-Type']).to have_content('application/json')
      expect(response.body).to match /.*title.*description.*/
    end
  end

  describe 'GET #unread_count' do
    it 'return unread rss feed count' do
      get :unread_count, params: {user_id: user.id}
      expect(response).to have_http_status(:success)
      expect(response.headers['Content-Type']).to have_content('application/json')
      expect(response.body).to match(/.*unread_count.*:\d+.*/)
    end
  end
end
