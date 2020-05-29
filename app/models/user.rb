class User < ApplicationRecord
  has_many :probe_settings
  has_many :pdd_web_spider_settings

  has_many :user_rss_feed_ship
  has_many :rss_feeds, :through => :user_rss_feed_ship

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def admin?
    self.role == 'admin'
  end
end
