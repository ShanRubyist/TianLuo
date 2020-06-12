require_relative 'web_spider'

class PDDWebSpider < WebSpider
  attr_accessor :platform

  def initialize(url, options = {})
    super(url, options)
    @platform = :PDD
  end

  # 处理网页源数据
  def handle(response)
    begin
      raw_data = response.scan(/<script>.*window.rawData.*?({.*?);\s*<\/script>/m).join('')
      json_data = JSON.load(raw_data)
      raise NeedLoginException if json_data["store"]["initDataObj"]["needLogin"]
    rescue JSON::ParserError => e
      logger.error(e)
      raise ParseException
    rescue => e
      logger.error(e)
      raise e
    end
    json_data
  end

  # 把数据转化成系统需要的格式
  def transform_data(data)
    data = data["store"]["initDataObj"]
    shop = data["mall"]
    goods = data["goods"]
    comments = data["oakData"]

    {
        useAgent: data['userAgent'],
        shop: {
            id: shop["mallID"],
            name: shop["mallName"],
            goods_num: shop["goodsNum"],
            shop_url: shop["pddRoute"],
            sales_num: shop["salesTip"],
            dsr: {
                logistics_score: shop["dsr"]["logisticsScore"],
                desc_score: shop["dsr"]["descScore"],
                service_score: shop["dsr"]["serviceScore"],
                desc_rank_percent: shop["dsr"]["descRankPercent"],
                service_rank_percent: shop["dsr"]["serviceRankPercent"],
                logistics_rank_percent: shop["dsr"]["logisticsRankPercent"],
                desc_rank_status: shop["dsr"]["descRankStatus"],
                service_rank_status: shop["dsr"]["serviceRankStatus"],
                logistics_rank_status: shop["dsr"]["logisticsRankStatus"],
            }
        },
        goods: {
            id: goods["goodsID"],
            name: goods["goodsName"],
            images: goods["viewImageData"],
            sales_num: goods["sideSalesTip"],
            coupons: data["lisbonInfo"]["mallCoupons"].map do |coupon|
              {
                  name: coupon["batchName"]
              }
            end,
            services: goods["mallService"]["service"].map do |service|
              {
                  name: service["type"]
              }
            end,
            comments: {
                comments_num: comments["review"]["commentNumText"],
                details: comments["review"]["detailList"].map do |detail|
                  {
                      customer_name: detail["name"],
                      comment: detail["comment"],
                      time: detail["time"]
                  }
                end
            },
            skus: goods["skus"].map do |sku|
              {
                  skuid: sku["skuID"],
                  normal_price: sku["normalPrice"],
                  group_price: sku["groupPrice"],
                  spec: sku["specs"].map { |spec| spec["spec_value"] }.join("\x20")
              }
            end,
        }
    }
  end

  private

  # def default_config
  #   config = super
  #   config['headers'].merge!({
  #                       cookies: ''
  #                   })
  # end

  class PDDWebSpiderException < WebSpiderException
  end

  class NeedLoginException < PDDWebSpiderException
  end
end
