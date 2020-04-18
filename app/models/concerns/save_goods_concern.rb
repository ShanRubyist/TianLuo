# frozen_string_literal: true

module SaveGoodsConcern
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def store_goods_to_db(pdd_web_spider_setting, data)
      # TODO: 如果 shop 已经存在，不能再创建
      shop = Shop.create(vendor_id: data[:shop][:id],
                         shop_name: data[:shop][:name],
                         shop_url: data[:shop][:shop_url],
                         sales_num: data[:shop][:sales_num],
                         goods_num: data[:shop][:goods_num],
                         platform: Platform.find_by_name('拼多多'),
                         pdd_web_spider_setting: pdd_web_spider_setting)

      shop.dsrs.create(logistics_score: data[:shop][:dsr][:logistics_score],
                       desc_score: data[:shop][:dsr][:desc_score],
                       service_score: data[:shop][:dsr][:service_score],
                       desc_rank_percent: data[:shop][:dsr][:desc_rank_percent],
                       service_rank_percent: data[:shop][:dsr][:service_rank_percent],
                       logistics_rank_percent: data[:shop][:dsr][:logistics_rank_percent],
                       desc_rank_status: data[:shop][:dsr][:desc_rank_status],
                       service_rank_status: data[:shop][:dsr][:service_rank_status],
                       logistics_rank_status: data[:shop][:dsr][:logistics_rank_status])

      goods = shop.goods.create(name: data[:goods][:id],
                                spu_id: data[:goods][:id],
                                sales_num: data[:goods][:sales_num],
                                comments_total_num: data[:goods][:comments][:comments_num])

      data[:goods][:images].each { |image| goods.goods_images.create(url: image) }
      data[:goods][:coupons].each { |coupon| goods.coupons.create(name: coupon[:name]) }
      data[:goods][:services].each { |service| goods.mall_services.create(name: service[:name]) }
      data[:goods][:comments][:details].each do |comment|
        goods.goods_comments.create(customer_name: comment[:customer_name],
                                    comment: comment[:comment],
                                    time: comment[:time])
      end

      data[:goods][:skus].each do |sku|
        goods.skus.create(skuid: sku[:skuid],
                          spec: sku[:spec],
                          normal_price: sku[:normal_price],
                          group_price: sku[:group_price])
      end
    end
  end
end
