require 'rails_helper'

RSpec.describe ProbeSettingsController, type: :controller do
  # let(:probe_setting) { FactoryBot.create(:probe_setting) }

  login_user

  describe 'GET #index' do
    it 'access to index path' do
      get :index
      expect(response).to render_template("index")
    end

    it 'has 0 rss job' do
      get :index
      expect(assigns(:running_rss_jobs_count)).to eq 0
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'save the new probe setting' do
        expect {
          post :create, params: {probe_setting: FactoryBot.attributes_for(:probe_setting)}
        }.to change(ProbeSetting, :count).by(1)

        post :create, params: {probe_setting: FactoryBot.attributes_for(:probe_setting)}
        expect(assigns(:probe_setting).url).to eq(FactoryBot.attributes_for(:probe_setting).fetch(:url))
      end

      login_admin

      it 'save the same probe setting with another user' do
        post :create, params: {probe_setting: FactoryBot.attributes_for(:probe_setting)}

        expect {
          post :create, params: {probe_setting: FactoryBot.attributes_for(:probe_setting)}
        }.to change(ProbeSetting, :count).by(0)
      end
    end

    context 'with invalid params' do
      it 'raise ActiveRecord::NotNullViolation' do
        # expect {
        #   post :create, params: {probe_setting: FactoryBot.attributes_for(:invalid_probe_setting)}
        # }.to raise_error(ActiveRecord::NotNullViolation)

        post :create, params: {probe_setting: FactoryBot.attributes_for(:invalid_probe_setting)}
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the probe setting' do
      # user = FactoryBot.create(:user)
      probe_setting = FactoryBot.create(:probe_setting, users: [User.first])

      expect {
        delete :destroy, params: {id: probe_setting.id}
      }.to change(UserRssShip, :count).by(-1)

      # expect(response).to redirect_to probe_setting_path
    end
  end
end
