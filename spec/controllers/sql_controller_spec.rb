require 'rails_helper'

RSpec.describe SqlController, type: :controller do
  describe 'SQL #exec' do
    context 'with admin access' do
      login_admin

      it 'exec sql statment' do
        post :sql, params: {sql: 'select 1'}
        # expect(response).to render_template(:sql)
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/javascript")
      end

      it 'return error' do
        post :sql, params: {sql: '1'}
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/javascript")
      end
    end

    context 'without admin access' do
      login_user

      it 'redirect to refer path or root path' do
        post :sql, params: {sql: 'select 1'}
        # expect(response).to render_template(:sql)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
