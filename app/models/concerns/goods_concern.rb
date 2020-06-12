module GoodsConcern
  extend ActiveSupport::Concern

  included do |base|
    def goods_list(page = 1, per = 20)
      # goods = Good.includes(
      #     :shop => {
      #         :pdd_web_spider_setting => :user
      #     }
      # ).includes(
      #     :shop => :shops_extras,
      #     :shop => :dsrs,
      #     :shop => :platform,
      # ).includes(
      #     :goods_extras,
      #     :mall_services,
      #     :goods_comments,
      #     :coupons,
      #     :goods_images,
      #     :skus
      # ).includes(
      #     :skus => :skus_extras
      # ).where(:users => {:id => current_user.id}).page(page).per(per)

      goods = Good.includes(
          :shop => {
              :pdd_web_spider_setting => :user
          }
      ).where(:users => {:id => current_user.id}).page(page).per(per)

      goods_hash = {}

      goods.map do |good|
        good_hash = {}
        good_hash['mall_services'] = good.mall_services.last.try(:services)
        good_hash['coupons'] = good.coupons.last.try(:coupons)
        good_hash['goods_images'] = good.goods_images.last.try(:goods_images)

        good_hash['skus'] = {}
        good.skus.map do |sku|
          sku_hash = {}
          sku_hash['skuid'] = sku.skuid
          sku_hash['spec'] = sku.skus_extras.last.try :spec
          sku_hash['normal_price'] = sku.skus_extras.last.try :normal_price
          sku_hash['group_price'] = sku.skus_extras.last.try :group_price

          good_hash['skus'][sku.skuid] = sku_hash
        end

        good_hash['goods_comments'] = {}
        good_hash['goods_comments'] = good.goods_comments.map do |goods_comment|
          goods_comments_hash = {}
          goods_comments_hash['customer_name'] = goods_comment.customer_name
          goods_comments_hash['comment'] = goods_comment.comment
          goods_comments_hash['time'] = goods_comment.time.localtime.strftime("%Y-%m-%d %H:%M")

          # good_hash['goods_comments'][goods_comment.customer_name + goods_comment.time.to_s] = goods_comments_hash
          [
              goods_comments_hash['customer_name'],
              goods_comments_hash['comment'],
              goods_comments_hash['time']
          ]
        end

        good_hash['name'] = good.goods_extras.last.try :name
        good_hash['spu_id'] = good.spu_id
        good_hash['sales_num'] = good.goods_extras.last.try :sales_num
        good_hash['comments_total_num'] = good.goods_extras.last.try :comments_total_num

        good_hash['vendor_id'] = good.shop.vendor_id
        good_hash['shop_name'] = good.shop.shop_name
        good_hash['shop_url'] = '//yangkeduo.com/' + good.shop.shop_url
        good_hash['shop_sales_num'] = good.shop.shops_extras.last.try :sales_num
        good_hash['goods_num'] = good.shop.shops_extras.last.try :goods_num
        good_hash['platform'] = good.shop.platform.name
        good_hash['logistics_score'] = good.shop.dsrs.last.try :logistics_score
        good_hash['desc_score'] = good.shop.dsrs.last.try :desc_score
        good_hash['service_score'] = good.shop.dsrs.last.try :service_score

        goods_hash[good.spu_id] = good_hash
      end
      goods_hash
    end
  end

  module ClassMethods
  end
end