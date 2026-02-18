xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.opml version: '2.0' do
  xml.head do
    xml.title 'RSS Subscriptions'
    xml.dateCreated Time.current.xmlschema
  end
  xml.body do
    @probe_settings.each do |probe_setting|
      xml.outline type: 'rss', text: probe_setting.url, xmlUrl: probe_setting.url
    end
  end
end
