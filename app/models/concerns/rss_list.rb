module RSSList
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def rss_list(user_id, page = 1, per = 100)
      # FIXME: 修改用 AR 来实现
      ProbeSetting.find_by_sql(<<-SQL
      select ps.id as id,
        count(case when unread = true and urfs.user_id = #{user_id}
          then 1
          else NULL
        end) as unread_count
      from probe_settings as ps
      inner join user_rss_ships as urs
      on urs.user_id = #{user_id} and urs.probe_setting_id = ps.id
      left join rss_feeds as rf
        on rf.probe_setting_id = ps.id
      left join user_rss_feed_ships as urfs
        on urfs.rss_feed_id = rf.id
      left join rss_infos as ri
        on ri.probe_setting_id = ps.id
      group by ps.id
      limit #{per}
      offset #{ (page - 1) * per }
      SQL
      )
    end
  end
end
