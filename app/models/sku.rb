class Sku < ApplicationRecord
  belongs_to :good
  has_many :skus_extras
end
