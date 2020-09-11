class GoodsController < ApplicationController
  def coupons
    if good = Coupon.includes(:good).where(:goods => {spu_id: params[:good_id]}).order("coupons.created_at desc").limit(10)
      prev = good.first
      period = good.first
      rst = good.map do |coupon|
        changed = (coupon.coupons.sort == prev.coupons.sort) ? '暂无变动' : '有变动'

        has_last = nil
        if changed || has_last.nil?
          has_last = period.created_at - coupon.created_at
          period = coupon
        end

        prev = coupon
        {
            coupons: coupon.coupons,
            changed: changed,
            from_when: coupon.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
            has_last: human_how_long_after(has_last)
        }
      end
      render json: rst.to_json
    else
      render json: {}
    end
  end

  def prices
    if good = SkusExtra.includes(:sku => :good).where(:goods => {spu_id: params[:good_id]})
      specs = good.map(&:spec).uniq!

      rlt = {
          legend: specs,
          data: specs.map do |spec|
            {
                spec: spec,
                prices: SkusExtra.where("spec = ?", spec)
                            .order("created_at asc")
                            .last(7)
                            .map(&:group_price)
            }
          end,
          time: SkusExtra.where("spec = ?", specs.first)
                    .order("skus_extras.created_at asc")
                    .last(7)
                    .map { |item| item.created_at.localtime.strftime("%Y-%m-%d %H:%M") }
      }
      render json: rlt.to_json
    else
      render json: {}
    end
  end

  private

  def human_how_long_after(sec)
    return unless sec

    if sec < 60 * 60
      "已使用 #{sec.to_i / 60} 分钟"
    elsif sec < 60 * 60 * 24
      "已使用 #{sec.to_i / (60 * 60)} 小时"
    elsif sec < 60 * 60 * 24 * 365
      "已使用 #{sec.to_i / (60 * 60 * 24)} 天"
    else
      "已使用 #{sec.to_i / (60 * 60 * 24 * 365)} 年"
    end
  end

end
