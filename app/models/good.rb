class Good < ApplicationRecord
  belongs_to :shop
  has_many :goods_comments
  has_many :mall_services
  has_many :coupons
  has_many :goods_images
  has_many :skus

  include SaveGoodsConcern
end
