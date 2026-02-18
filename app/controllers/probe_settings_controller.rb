class ProbeSettingsController < ApplicationController
  include RunningJosbsCountable
  include ApplicationHelper

  skip_before_action :authenticate_user!, only: [:opml]

  # for mobile
  def index
    @running_rss_jobs_count = running_rss_jobs_count

    per ||= 200
    params['page'] ||= 1

    render 'rss/rss/mobile/index'
  end

  def create
    @probe_setting = ProbeSetting
                       .create_with(retry_limit: params[:probe_setting][:retry_limit],
                                    proxy: params[:probe_setting][:proxy],
                                    status: params[:probe_setting][:status])
                       .find_or_create_by(url: params[:probe_setting][:url],
                                          port: params[:probe_setting][:port])

    @probe_setting.users << current_user unless @probe_setting.users.include?(current_user)

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
    if probe_setting && probe_setting.destroy
      render json: {message: '删除成功'}
    else
      render json: {message: '记录不存在'}
    end
  end

  def opml
    @probe_settings = ProbeSetting.all

    respond_to do |format|
      format.xml { render layout: false }
    end
  end

  private

  def probe_setting_params
    # params[:probe_setting][:user_id] = current_user.id
    params.require(:probe_setting).permit(:url, :port, :retry_limit, :proxy, :status, :user_id)
  end
end
