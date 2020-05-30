class HomeController < ApplicationController
  include RSSConcern
  include GoodsConcern

  def index
    @rss_list = rss_list
    @goods_list = goods_list(params['page'], params['per'])
  end

end
