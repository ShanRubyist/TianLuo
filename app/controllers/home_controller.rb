# frozen_string_literal: true

class HomeController < ApplicationController
  include RssReadable
  include GoodsReadable

  def index
    @rss_list = rss_list
    @goods_list = goods_list(params['page'], params['per'])

    @unread_count = UserRssFeedShip.where(user_id: current_user.id, unread: true).count

    per ||= 200
    params['page'] ||= 1

    # where urfs.user_id = #{current_user.id} and ps.user_id = #{current_user.id}
              @all_rss_list = ProbeSetting.find_by_sql(<<-SQL
select ps.id as id, count(case when unread = true then 1 else NULL end) as unread_count
from probe_settings as ps
left join rss_probe_histories as rph
on rph.probe_setting_id = ps.id
left join rss_feeds as rf
on rf.rss_probe_history_id = rph.id
left join user_rss_feed_ships as urfs
on urfs.rss_feed_id = rf.id
    where urfs.user_id = 1 and ps.user_id = 1
group by ps.id
      limit #{per}
      offset #{ (params['page'] - 1) * per }

    SQL
    )

    @all_rss_list_json = []

    @all_rss_list.each do |rss|
      rph = RssProbeHistory.find_by_probe_setting_id(rss.id)
      @all_rss_list_json << {
          probe_settings_id: rss.id,
          # rss: rss.url,
          # port: rss.port,
          # proxy: rss.proxy,
          # retry_limit: rss.retry_limit,
          # latest_updated: rss.last_build_date,
          # status: rss.refresh_status,
          # jid: rss.jid,
          # detail: rss.detail,
          title: rph.title,
          dscription: rph.description,
          unread_count: rss.unread_count
      }
    end


    render_view_for_device '/home/index'
  end

  private

  def render_view_for_device(temp)
    temp += ".#{render_device_path}"
    render template: temp
  end
end
