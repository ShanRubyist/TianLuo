require 'rails_helper'

RSpec.describe "Sqls", type: :request do
  context 'as admin' do
    login_admin

    it 'exec sql statement and render template sql' do
      post '/sql', params: {sql: 'select 1', format: 'js'}
      expect(response).to render_template(:sql)
    end

    it 'alert when exec invalid statement' do
      post '/sql', params: {sql: 'abc', format: 'js'}
      expect(response.body).to match(/alert\(.*\)/)
    end
  end

  context 'as normat user' do
    login_user

    it 'redirect to root_path' do
      post '/sql', params: {sql: 'select 1', format: 'js'}
      expect(response).to redirect_to(root_path)
    end
  end

  context 'as guest' do
    it 'show unauthorized' do
      post '/sql', params: {sql: 'select 1', format: 'js'}
      expect(response).to have_http_status('401')
    end
  end
end
