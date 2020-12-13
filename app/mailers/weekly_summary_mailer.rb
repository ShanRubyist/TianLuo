class WeeklySummaryMailer < ApplicationMailer
  def notify
    @users = User.count
    @rss_feeds = RssFeed
                     .includes(:user_rss_feed_ships)
                     .where(:user_rss_feed_ships => {:unread => true})
                     .select(:link)
                     .distinct
                     .count

    @rss_sources = ProbeSetting.select(:url).distinct(true).count

    admin_email = ENV['ADMIN_EMAIL']
    mail(to: admin_email, subject: 'TianLuo Weekly Summary')
  end
end
