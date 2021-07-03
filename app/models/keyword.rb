class Keyword < ApplicationRecord
  has_many :rssfeed_keyword_ships
  has_many :rss_feeds, :through => :rssfeed_keyword_ships

  def self.sentence_to_vectors(sentence)
    sentence = sentence.gsub(/<.*?>/, '')
                   .gsub(/\\n/, '')
                   .gsub(/'/, '')
    # .dump
    # .gsub(/\\n/, '')
    # .gsub(/^\"|\"$/, '\'')

    Keyword.find_by_sql("select to_tsvector('testzhcfg', '" + sentence + "\')")
  end

  def self.fetch_new_rss_feed
    max_fetch_count = 5000
    sql_str = <<-STR
      select *
      from rss_feeds
      where id > (
        select (case when max(rss_feed_id) is null then 0 else max(rss_feed_id) end)
        from keywords
        left join rssfeed_keyword_ships rks
        on rks.keyword_id = keywords.id
      )
      order by id asc limit #{max_fetch_count}
    STR
    RssFeed.find_by_sql(sql_str)
  end

  def self.insert_word_into_db
    rss_feeds = fetch_new_rss_feed

    # puts "总共 #{rss_feeds.size} 条记录"
    # index = 0
    rss_feeds.each do |rss_feed|
      # index += 1
      # puts "当前处理第 #{index} 条记录"
      vectors = sentence_to_vectors(rss_feed.description)
      vectors.each do |vector|
        vector = vector["to_tsvector"]
        vector.split(' ').each do |pair|
          word = pair.split(':').first[1...-1]
          position = pair.split(':').last.split(',')
          keyword = Keyword.find_or_create_by(word: word)
          RssfeedKeywordShip.create(keyword: keyword, rss_feed: rss_feed, position: position)
        end
      end
    end
  end
end
