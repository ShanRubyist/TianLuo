# frozen_string_literal: true

class HomeController < ApplicationController
  include RssReadable
  include GoodsReadable

  def index
    @rss_list = rss_list
    @goods_list = goods_list(params['page'], params['per'])

    render_view_for_device '/home/index'
  end

  private
  def render_view_for_device(temp)
    temp += ".#{render_device_path}"
    render template: temp
  end
end
