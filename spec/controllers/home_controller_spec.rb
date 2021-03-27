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
