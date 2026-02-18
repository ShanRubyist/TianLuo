xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: '2.0' do
  xml.channel do
    xml.title 'Daily RSS Feeds'
    xml.link request.base_url
    xml.description "Today's RSS feeds"
    xml.language 'zh-CN'
    xml.lastBuildDate Time.current.rfc822

    @rss_feeds.each do |feed|
      xml.item do
        xml.title feed.title
        xml.link feed.link
        xml.description feed.description
        xml.author feed.author if feed.author.present?
        xml.pubDate feed.pub_date&.rfc822 || feed.created_at.rfc822
        xml.guid feed.link
        if feed.enclosure.present?
          xml.enclosure url: feed.enclosure, type: 'audio/mpeg'
        end
      end
    end
  end
end
