class HomeController < ApplicationController
  include RSSConcern

  def index
    @rss_list = rss_list(params['page'], params['per'])
  end

end
