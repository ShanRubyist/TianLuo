class RssProbeHistory < ApplicationRecord
  belongs_to :probe_setting
  has_many :rss_feeds

  def self.find_by_probe_setting_id(setting_id, page = 1, per = 10)
    # FIXME: 修改用 AR 来实现
    RssProbeHistory.find_by_sql(<<-SQL
                  select rph.*,
                    count(rf.id) as new_feeds_count,
                    to_char(rph.created_at at time zone 'pst', 'yyyy-mm-dd hh24:mi:ss') as created_at_local_time
                  from rss_probe_histories as rph
                  left join probe_settings as ps
                    on ps.id = rph.probe_setting_id
                  left join rss_feeds as rf
                    on rph.id = rf.rss_probe_history_id
                  where ps.id = #{setting_id}
                  group by rph.id
                  order by rph.created_at desc
                  limit #{per}
                  offset #{ (page - 1) * per }
    SQL
    )
  end
end
