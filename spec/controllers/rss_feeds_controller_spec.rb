require 'rails_helper'

RSpec.describe RssFeedsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:probe_setting) { FactoryBot.create(:probe_setting, users: [user]) }
  let(:rss_feed) { FactoryBot.create(:rss_feed1, probe_setting: probe_setting) }
  let(:rss_info) { FactoryBot.create(:rss_info, rss_feed) }

  before do
    rss_feed.users = [user]
    rss_feed.save!
  end

  login_user

  describe 'GET #index' do
    it 'access to index path' do
      get :index, params: {format: :json}
      expect(response).to render_template("index")
    end
  end

  describe 'GET #briefly_info' do
    it 'get rss feed briefly info' do
      get :briefly_info, params: { current_rss: probe_setting.id }
      expect(response.body).to match /.*total_num_of_current_rss.*total_unread_count_of_current_rss.*/
    end
  end

  describe 'PUT #mark_all_as_read' do
    it 'mark all rss feed readed' do
      patch :mark_all_as_read, params: { user_id: user.id}
      expect(response).to have_http_status(:success)
      expect(UserRssFeedShip.where(user: user, unread: true).count).to eq 0
    end

    it 'change status' do
      expect {
        patch :mark_all_as_read, params: { user_id: user.id}
      }.to change(UserRssFeedShip.where(unread: true), :count).by(-1)
    end

    # it 'should have enqueued UpdateUserRssJob jobs' do
    #   ActiveJob::Base.queue_adapter = :test
    #   expect {
    #     patch :mark_all_as_read, params: { user_id: user.id }
    #   }.to have_enqueued_job(UpdateUserRssJob)
    # end

    it 'mark specific rss feed readed' do
      patch :mark_all_as_read, params: { user_id: user.id, rss_feed_id: rss_feed.id}
      expect(response).to have_http_status(:success)
      expect(UserRssFeedShip.find_by(user: user, rss_feed: rss_feed).unread).to eq false
    end
  end

  describe 'GET #load_more_rss_feed' do
    # let(:user) { FactoryBot.create(:user) }
    it 'load more rss feed in text/html content type' do
      get :load_more_rss_feed, params: {user_id: user.id, rss: probe_setting.id}, format: :json
      expect(response.headers['Content-Type']).to have_content('application/json')
      expect(response).to render_template('rss_feeds/load_more_rss_feed')

      # expect(user.probe_settings).to eq [probe_setting]
      # expect(rss_feed.users).to eq [user]
      # expect(UserRssFeedShip.first).to eq ['abc']
      # rst = RssFeed.includes(:user_rss_feed_ships)
      #           .includes(:probe_setting)
      #           .includes(:probe_setting => :rss_info)
      #           .where(:user_rss_feed_ships => {:user_id => user.id})
      #
      # rst = rst.where(:probe_settings => {:id => probe_setting.id})
      #
      # rst.order('user_rss_feed_ships.unread desc')
      #     .order_by_desc
      #     .page(1)
      #     .per(100)
      # expect(rst).to match /.*abc*/

      # expect(response.body).to match /.*title.*description.*/
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
