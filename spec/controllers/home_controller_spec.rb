require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  context 'before login' do
    describe 'GET #index' do
      it 'returns http redirect' do
        get :index
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  context 'after login' do
    login_user
    context "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
