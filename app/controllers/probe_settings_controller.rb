class ProbeSettingsController < ApplicationController
  include RunningJosbsCountable
  include ApplicationHelper
  include RSSList

  # for mobile
  def index
    @running_rss_jobs_count = running_rss_jobs_count

    per ||= 200
    params['page'] ||= 1

    @all_rss_list = rss_list

    @all_rss_list_json = []

    @all_rss_list.each do |rss_id|
      rss = ProbeSetting.find_by_id(rss_id)

      @all_rss_list_json << {
          probe_settings_id: rss.id,
          rss: rss.url,
          port: rss.port,
          proxy: rss.proxy,
          retry_limit: rss.retry_limit,
          latest_updated: rss.rss_probe_histories.last.last_build_date,
          status: rss.rss_probe_histories.last.status,
          jid: rss.rss_probe_histories.last.jid,
          detail: rss.rss_probe_histories.last.detail
      }
    end
    render template: 'rss/rss/mobile/index'
  end

  def create
    @probe_setting = ProbeSetting.new(probe_setting_params)
    @probe_setting.users = [current_user]

    respond_to do |format|
      if @probe_setting.save
        format.html { redirect_to probe_settings_path, notice: 'probe_setting was successfully created.' }
        format.js { redirect_to probe_settings_path, notice: 'probe_setting was successfully created.' }
        # format.json { render :show, status: :created, location: @probe_setting }
        format.json { render json: {message: 'Created Success'} }

      else
        format.html { render :new }
        format.js { render :new }
        format.json { render json: @probe_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    probe_setting = UserRssShip.find_by(user_id: current_user.id, probe_setting_id: params[:id])
    if probe_setting
      probe_setting.destroy
      render json: {message: '删除成功'}
    else
      render json: {message: '记录不存在'}
    end
  end

  private

  def probe_setting_params
    params[:probe_setting][:user_id] = current_user.id
    params.require(:probe_setting).permit(:url, :port, :retry_limit, :proxy, :status, :user_id)
  end
end
