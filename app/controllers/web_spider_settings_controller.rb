class WebSpiderSettingsController < ApplicationController
  def create
    @web_spider_setting = PddWebSpiderSetting.new(web_spider_setting_params)

    respond_to do |format|
      if @web_spider_setting.save
        format.html { redirect_to web_spider_settings_path, notice: 'web_spider_setting was successfully created.' }
        format.js { redirect_to web_spider_settings_path, notice: 'web_spider_setting was successfully created.' }
        format.json { render json: { message: 'Created Success' } }
        # format.json { render :show, status: :created, location: @web_spider_setting }
      else
        format.html { render :new }
        format.js { render :new }
        format.json { render json: @web_spider_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    probe_setting = PddWebSpiderSetting.find(params[:probe_setting_id])
    probe_setting.destroy
    render json: { message: '删除成功'}
  end

  private

  def web_spider_setting_params
    params[:web_spider_setting][:user_id] = current_user.id
    params.require(:web_spider_setting).permit(:url, :port, :retry_limit, :proxy, :status, :cookies, :user_id)
  end
end

