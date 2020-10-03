# frozen_string_literal: true
require 'sidekiq/api'

class HomeController < ApplicationController
  include RSSConcern
  include GoodsConcern
  include RSSSettingListConcern

  def index
    @rss_list = rss_list
    @goods_list = goods_list(params['page'], params['per'])
  end

  def all
    @running_rss_jobs_count = running_rss_jobs_count
    @running_goods_jobs_count = running_goods_jobs_count

    per ||= 200
    params['page'] ||= 1

    @all_rss_list = ProbeSetting.find_by_sql(<<-SQL
      select histories.status as refresh_status, *
      from probe_settings as ps
      left join (
            select probe_setting_id, jid, status, detail, last_build_date
            from rss_probe_histories
            where (probe_setting_id, created_at) in (
              select probe_setting_id, max(created_at) as latest
              from rss_probe_histories
              group by probe_setting_id
            )
      ) as histories
      on histories.probe_setting_id = ps.id
      where user_id = #{current_user.id}
      order by ps.created_at desc
      limit #{per}
      offset #{ (params['page'] - 1) * per }
    SQL
    )

    @all_rss_list_json = []

    @all_rss_list.each do |rss|
      @all_rss_list_json << {
          probe_settings_id: rss.id,
          rss: rss.url,
          port: rss.port,
          proxy: rss.proxy,
          retry_limit: rss.retry_limit,
          latest_updated: rss.last_build_date,
          status: rss.refresh_status,
          jid: rss.jid,
          detail: rss.detail
      }
    end
    @all_good_list = PddWebSpiderSetting.where(user: current_user).all

    render template: 'home/all/all'
  end

  def running_jobs_count
    respond_to do |format|
      format.json do
        render json: {
            running_rss_jobs_count: running_rss_jobs_count,
            running_goods_jobs_count: running_goods_jobs_count
        }
      end
    end
  end

  def start_job
    setting = nil

    job_class = case params['type']
                when 'RssWorkJob'
                  setting = ProbeSetting.find(params['id'])
                  RssWorkJob
                when 'WebSpiderWorkJob'
                  setting = PddWebSpiderSetting.find(params['id'])
                  WebSpiderWorkJob
                end

    rst = job_class.perform_later(setting)
    rst ? render(json: {message: '任务启动成功!'}) : render(json: nil, status: 502)
  end

  def delete_job
    job = Sidekiq::Queue.new.find_job(params['jid'])

    begin
      job.delete
      render json: {message: '任务停止成功!'}
    rescue => e
      render json: nil, status: 502
    end
  end

  def histories
    params[:page] = (params[:page].to_i < 1) ? 1 : params[:page]

    rst = RssProbeHistory
              .find_by_sql(<<-SQL
                  select rph.*, count(rf.id) as new_feeds_count, to_char(rph.created_at at time zone 'cst', 'yyyy-mm-dd hh24:mi:ss') as created_at_local_time
                  from rss_probe_histories as rph
                  left join probe_settings as ps
                  on ps.id = rph.probe_setting_id
                  left join rss_feeds as rf
                  on rph.id = rf.rss_probe_history_id
                  where ps.id = #{params[:setting_id]}
                  group by rph.id
                  order by rph.created_at desc
                  limit 10
                  offset #{ (params[:page].to_i - 1) * 10 }
          SQL
          )
    render json: rst.to_json
  end
end
