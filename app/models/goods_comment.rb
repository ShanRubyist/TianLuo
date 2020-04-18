class GoodsComment < ApplicationRecord
  belongs_to :good, counter_cache: true
end
