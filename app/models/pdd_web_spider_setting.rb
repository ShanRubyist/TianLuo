class PddWebSpiderSetting < ApplicationRecord
  belongs_to :user
  has_many :shops
  has_many :goods_refresh_histories
end
