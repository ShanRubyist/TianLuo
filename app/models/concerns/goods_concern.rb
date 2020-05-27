module GoodsConcern
  extend ActiveSupport::Concern

  included do |base|
    def goods_list(page = 1, per = 20)
      goods = Good.includes(
          :shop => {
              :pdd_web_spider_setting => :user
          }
      ).includes(
          :shop => :dsrs,
          :shop => :platform
      ).includes(
          :mall_services,
          :goods_comments,
          :coupons,
          :goods_images,
          :skus
      ).where(:users => {:id => current_user.id}).page(page).per(per)

      goods_hash = {}

      goods.map do |good|
        good_hash = {}
        good_hash['mall_services'] = good.mall_services.map(&:name)
        good_hash['coupons'] = good.coupons.map(&:name)
        good_hash['goods_images'] = good.goods_images.map(&:url)

        good_hash['skus'] = {}
        good.skus.map do |sku|
          sku_hash = {}
          sku_hash['skuid'] = sku.skuid
          sku_hash['spec'] = sku.spec
          sku_hash['normal_price'] = sku.normal_price
          sku_hash['group_price'] = sku.group_price

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

        good_hash['name'] = good.name
        good_hash['spu_id'] = good.spu_id
        good_hash['sales_num'] = good.sales_num
        good_hash['comments_total_num'] = good.comments_total_num

        good_hash['vendor_id'] = good.shop.vendor_id
        good_hash['shop_name'] = good.shop.shop_name
        good_hash['shop_url'] = '//yangkeduo.com/' + good.shop.shop_url
        good_hash['shop_sales_num'] = good.shop.sales_num
        good_hash['goods_num'] = good.shop.goods_num

        good_hash['platform'] = good.shop.platform.name
        good_hash['logistics_score'] = good.shop.dsrs.first.logistics_score
        good_hash['desc_score'] = good.shop.dsrs.first.desc_score
        good_hash['service_score'] = good.shop.dsrs.first.service_score

        goods_hash[good.spu_id] = good_hash
      end
      goods_hash
    end
  end

  module ClassMethods
  end
end