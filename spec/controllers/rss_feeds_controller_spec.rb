require 'rails_helper'

RSpec.describe RssFeedsController, type: :controller do
  describe '#mark_read' do
    let(:user) { FactoryBot.create(:user) }

    login_user

    it 'mark all rss feed readed' do
      patch :mark_readed, params: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe '#load_more_rss_feed' do
    let(:user) { FactoryBot.create(:user) }
    let(:page) { 1 }
    let(:per) { 10 }

    login_user

    it 'is text/html content type' do
      get :load_more_rss_feed, params: { user_id: user.id }
      expect(response.headers['Content-Type']).to have_content('application/json')
    end
  end
end
