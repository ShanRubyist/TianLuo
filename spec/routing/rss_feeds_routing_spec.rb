require 'rails_helper'

RSpec.describe 'RssFeedsController', type: :routing do
  describe 'routing' do
    it 'routes to #unread_count' do
      expect(get: "/rss_feeds/unread_count").to route_to("rss_feeds#unread_count")
    end

    it 'routes to #mark_all_as_read' do
      expect(put: "/rss_feeds/mark_all_as_read").to route_to("rss_feeds#mark_all_as_read")
    end

    it 'routes to #load_more_rss_feed' do
      expect(get: "/rss_feeds/load_more_rss_feed").to route_to("rss_feeds#load_more_rss_feed")
    end

    it 'routes to #index' do
      expect(get: "/rss_feeds").to route_to("rss_feeds#index")
    end

    it 'routes to #briefly_info' do
      expect(get: '/rss_feeds/briefly_info').to route_to('rss_feeds#briefly_info')
    end
  end

  describe 'routes with format' do
    it 'routes to #unread_count' do
      expect(get: "/rss_feeds/unread_count.json").to route_to("rss_feeds#unread_count", { format: 'json'})
    end

    it 'routes to #mark_all_as_read' do
      expect(put: "/rss_feeds/mark_all_as_read.json").to route_to("rss_feeds#mark_all_as_read", { format: 'json'})
    end

    it 'routes to #load_more_rss_feed' do
      expect(get: "/rss_feeds/load_more_rss_feed.json").to route_to("rss_feeds#load_more_rss_feed", { format: 'json'})
    end

    it 'routes to #index' do
      expect(get: "/rss_feeds.json").to route_to("rss_feeds#index", { format: 'json'})
    end
  end
end