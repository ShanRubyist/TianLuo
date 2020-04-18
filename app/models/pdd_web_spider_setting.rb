class PddWebSpiderSetting < ApplicationRecord
  belongs_to :user
  has_many :shops
end
