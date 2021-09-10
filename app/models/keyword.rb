class Keyword < ApplicationRecord
  has_many :rssfeed_keyword_ships
  has_many :rss_feeds, :through => :rssfeed_keyword_ships

  class << self
    def sentence_to_vectors(sentence)
      sentence = sentence.gsub(/<.*?>/, '')
                     .gsub(/\\n/, '')
                     .gsub(/'/, '') unless sentence.nil? #|| sentence.present?
      # .dump
      # .gsub(/\\n/, '')
      # .gsub(/^\"|\"$/, '\'')

      Keyword.find_by_sql("select to_tsvector('testzhcfg', '" + sentence.to_s + "\')")
    end

    def fetch_new_rss_feed
      max_fetch_count = 50_000
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

    def insert_word_into_db
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

            tf = tf(rss_feed.id, keyword.id)
            idf = idf(keyword.id)
            tf_idf = tf * idf
            RssfeedKeywordShip.create(keyword: keyword,
                                      rss_feed: rss_feed,
                                      position: position,
                                      tf: tf,
                                      idf: idf,
                                      tf_idf: tf_idf)
          end
        end

        best_matched_tag(rss_feed.id).each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
          keyword = Keyword.find_by(word: tag_name)

          # next unless keyword

          tf = tf(rss_feed.id, keyword.id)
          idf = idf(keyword.id)
          tf_idf = tf * idf

          RssFeedTagShip.create(tag: tag, rss_feed: rss_feed, tf_idf: tf_idf)
        end
      end
    end

    def idf(keyword_id)
      total_rss_feed_count = RssFeed.count
      rss_feed_contain_keyword_count = RssFeed
                                           .includes(:rssfeed_keyword_ships)
                                           .includes(:rssfeed_keyword_ships => :keyword)
                                           .where(:rssfeed_keyword_ships => {keyword_id: keyword_id})
                                           .count
      Math.log(total_rss_feed_count / (rss_feed_contain_keyword_count + 1))
    end

    def tf(rss_feed_id, keyword_id)
      keywords = RssfeedKeywordShip.where(rss_feed_id: rss_feed_id)

      total_keywords_count = keywords.inject(0) do |sum, keyword|
        sum + keyword.position.size
      end

      return 0 if total_keywords_count == 0

      keyword_count = RssfeedKeywordShip.find_by_rss_feed_id_and_keyword_id(rss_feed_id, keyword_id)&.position&.size

      keyword_count.to_f / Float(total_keywords_count)
    end

    def tf_idf(rss_feed_id)
      RssfeedKeywordShip.where(rss_feed_id: rss_feed_id).inject(0) do |sum, keyword|
        sum + tf(rss_feed_id, keyword.keyword_id) * idf(keyword.keyword_id)
      end
    end

    def best_matched_tag(rss_feed_id, threshold=0.1)
      tag = []
      prev_num = 0

      RssfeedKeywordShip.where(rss_feed_id: rss_feed_id).each do |keyword|
        number = tf(rss_feed_id, keyword.keyword_id) * idf(keyword.keyword_id)
        if number >= threshold #&& number >= prev_num
            prev_num = number
          tag << Keyword.find_by(id: keyword.keyword_id).word
          # tag << sprintf("%s(%2.2f)", Keyword.find_by(id: keyword.keyword_id).word, prev_num)
        end
      end
      tag
    end
  end
end
