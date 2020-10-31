require 'rails_helper'

RSpec.describe WebSpiderSettingsController, type: :controller do
  let(:pdd_web_spider_setting) { FactoryBot.create(:pdd_web_spider_setting) }

  login_user

  describe 'POST #create' do
    context 'with valid params' do
      it 'save the new web spider setting' do
        post :create, params: {web_spider_setting: FactoryBot.attributes_for(:pdd_web_spider_setting)}

        expect(assigns(:web_spider_setting).url).to eq(pdd_web_spider_setting.url)

        expect {
          post :create, params: {web_spider_setting: FactoryBot.attributes_for(:pdd_web_spider_setting)}
        }.to change(PddWebSpiderSetting, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'raise ActiveRecord::NotNullViolation' do
        expect {
          post :create, params: {web_spider_setting: FactoryBot.attributes_for(:invalid_pdd_web_spider_setting)}
        }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the web spider setting' do
      expect {
        delete :destroy, params: {web_spider_setting: pdd_web_spider_setting.id}
      }.to change(PddWebSpiderSetting, :count).by(-1)
    end
  end
end
