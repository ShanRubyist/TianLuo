# frozen_string_literal: true

module Histories
  class HistoriesController < ::ApplicationController
    def rss_histories
      params[:page] = (params[:page].to_i < 1) ? 1 : params[:page]

      rst = RssProbeHistory.find_by_probe_setting_id(params[:setting_id], params[:page].to_i)
      render json: rst.to_json
    end

    def goods_histories
      params[:page] = (params[:page].to_i < 1) ? 1 : params[:page]

      rst = GoodsRefreshHistory.find_by_setting_id(params[:setting_id], params[:page].to_i)
      render json: rst.to_json
    end

    def histories
      if params[:type] == '0'
        rss_histories
      elsif params[:type] == '1'
        goods_histories
      else
        render json: []
      end
    end
  end
end