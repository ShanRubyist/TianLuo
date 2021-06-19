class GoodsRefreshHistory < ApplicationRecord
  belongs_to :pdd_web_spider_setting

  def self.find_by_setting_id(setting_id, page=1, per=10)
    # FIXME: 修改用 AR 来实现
    GoodsRefreshHistory
              .find_by_sql(<<-SQL
                  select grh.*, to_char(grh.created_at at time zone 'pst', 'yyyy-mm-dd hh24:mi:ss') as created_at_local_time
                  from goods_refresh_histories as grh
                  where grh.pdd_web_spider_setting_id = #{setting_id}
                  order by grh.created_at desc
                  limit #{per}
                  offset #{ (page-1) * per }
          SQL
          )
  end
end
