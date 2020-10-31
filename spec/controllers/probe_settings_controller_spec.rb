require 'rails_helper'

RSpec.describe ProbeSettingsController, type: :controller do
  let(:probe_setting) { FactoryBot.create(:probe_setting) }

  login_user

  describe 'POST #create' do
    context 'with valid params' do
      it 'save the new probe setting' do
        post :create, params: {probe_setting: FactoryBot.attributes_for(:probe_setting)}

        expect(assigns(:probe_setting).url).to eq(probe_setting.url)

        expect {
          post :create, params: {probe_setting: FactoryBot.attributes_for(:probe_setting)}
        }.to change(ProbeSetting, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'raise ActiveRecord::NotNullViolation' do
        expect {
          post :create, params: {probe_setting: FactoryBot.attributes_for(:invalid_probe_setting)}
        }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the probe setting' do
      expect {
        delete :destroy, params: {probe_setting_id: probe_setting.id}
      }.to change(ProbeSetting, :count).by(-1)
    end
  end
end
