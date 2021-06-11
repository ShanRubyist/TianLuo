require 'rails_helper'

RSpec.describe 'ProbeSettingsController', type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: "/probe_settings").to route_to("probe_settings#index")
    end

    it 'routes to #create' do
      expect(post: "/probe_settings").to route_to("probe_settings#create")
    end

    it 'routes to #destroy' do
      expect(delete: "/probe_settings/1").to route_to("probe_settings#destroy", {id: '1'})
    end
  end

  describe 'routes with format' do
    it 'routes to #index' do
      expect(get: "/probe_settings.json").to route_to("probe_settings#index", {format: 'json'})
    end

    it 'routes to #create' do
      expect(post: "/probe_settings.json").to route_to("probe_settings#create", {format: 'json'})
    end

    it 'routes to #destroy' do
      expect(delete: "/probe_settings/1.json").to route_to("probe_settings#destroy", {format: 'json', id: '1'})
    end
  end
end