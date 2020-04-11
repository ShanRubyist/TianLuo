class RssProbeHistory < ApplicationRecord
  belongs_to :probe_setting
  has_many :rss_feeds

  def self.store_rss_to_db(probe_setting_id, rss)
    title = rss[:title]
    description = rss[:description]
    last_build_date = rss[:last_build_date]
    link = rss[:link]
    items = rss[:items]

    rss_probe_history = create(probe_setting_id: probe_setting_id,
                               title: title,
                               description: description,
                               last_build_date: last_build_date,
                               link: link)

    items.each do |item|
      rss_probe_history.rss_feeds.create(title: item[:title],
                                         description: item[:description],
                                         author: item[:author],
                                         pub_date: item[:pub_date],
                                         link: item[:link])
    end
  end
end
