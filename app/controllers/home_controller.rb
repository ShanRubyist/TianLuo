# frozen_string_literal: true

class HomeController < ApplicationController
  include RssReadable
  include GoodsReadable

  def index
    @rss_list = rss_list
    @goods_list = goods_list(params['page'], params['per'])
  end
end
