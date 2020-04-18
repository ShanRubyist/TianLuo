class Shop < ApplicationRecord
  belongs_to :pdd_web_spider_setting
  belongs_to :platform
  has_many :goods
  has_many :dsrs
end
