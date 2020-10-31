require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  shared_examples 'user access to home' do
    login_user

    describe 'GET #index' do
      it 'access to root path' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe 'GET #all' do
      it 'access to all path' do
        get :all
        expect(response).to render_template("all/all")
      end
    end

    describe 'GET #running_jobs_count' do
      it 'return running jobs count' do
        get :running_jobs_count, params: { format: 'json' }
        expect(response.content_type).to eq('application/json')
        expect(response.body).to match(/.*running_rss_jobs_count.*running_goods_jobs_count.*/)
      end
    end

    describe 'GET #histories' do
      it 'proxy to rss histories' do
        spy_controller = spy(controller)
        get :histories, params: { type: 0, setting_id: 1 }
        # expect(spy_controller).to have_received(:rss_histories)
      end
    end
  end

  shared_examples 'guess access to home' do
    describe 'GET #index' do
      it 'redirect to sign in path' do
        get :index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'user access to home' do
    it_behaves_like 'user access to home'
  end

  describe 'guess access to home' do
    it_behaves_like 'guess access to home'
  end
end
