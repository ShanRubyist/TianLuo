# frozen_string_literal: true

module SaveGoodsConcern
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def store_goods_to_db(pdd_web_spider_setting, data)
      shop = Shop.create_with(shop_name: data[:shop][:name],
                              shop_url: data[:shop][:shop_url],
                              platform: Platform.find_by_name('拼多多'),
                              pdd_web_spider_setting: pdd_web_spider_setting)
                 .find_or_create_by(vendor_id: data[:shop][:id])

      shop.shops_extras.create(shop_id: shop.id,
                               sales_num: data[:shop][:sales_num],
                               goods_num: data[:shop][:goods_num])

      shop.dsrs.create(logistics_score: data[:shop][:dsr][:logistics_score],
                       desc_score: data[:shop][:dsr][:desc_score],
                       service_score: data[:shop][:dsr][:service_score],
                       desc_rank_percent: data[:shop][:dsr][:desc_rank_percent],
                       service_rank_percent: data[:shop][:dsr][:service_rank_percent],
                       logistics_rank_percent: data[:shop][:dsr][:logistics_rank_percent],
                       desc_rank_status: data[:shop][:dsr][:desc_rank_status],
                       service_rank_status: data[:shop][:dsr][:service_rank_status],
                       logistics_rank_status: data[:shop][:dsr][:logistics_rank_status])

      goods = shop.goods.find_or_create_by(spu_id: data[:goods][:id])
      goods.goods_extras.create(good_id: goods.id,
                                name: data[:goods][:name],
                                sales_num: data[:goods][:sales_num],
                                comments_total_num: data[:goods][:comments][:comments_num])

      goods.goods_images.create(goods_images: data[:goods][:images].map { |image| image })
      goods.coupons.create(coupons: data[:goods][:coupons].map { |coupon| coupon[:name]})
      goods.mall_services.create(services: data[:goods][:services].map { |service| service[:name]})
      data[:goods][:comments][:details].each do |comment|
        goods.goods_comments.create(customer_name: comment[:customer_name],
                                    comment: comment[:comment],
                                    time: comment[:time])
      end

      data[:goods][:skus].each do |sku|
        _sku = goods.skus.find_or_create_by(skuid: sku[:skuid])

        _sku.skus_extras.create(sku_id: _sku.id,
                    spec: sku[:spec],
                    normal_price: sku[:normal_price],
                    group_price: sku[:group_price])
      end
    end
  end
end
