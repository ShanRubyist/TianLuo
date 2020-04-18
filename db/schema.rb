# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_18_124501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coupons", force: :cascade do |t|
    t.string "name", null: false, comment: "优惠卷名称"
    t.integer "good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_coupons_on_name"
  end

  create_table "dsrs", force: :cascade do |t|
    t.integer "logistics_score", comment: "物流评分"
    t.integer "desc_score", comment: "描述评分"
    t.integer "service_score", comment: "服务评分"
    t.integer "logistics_rank_percent", comment: "物流排行"
    t.integer "desc_rank_percent", comment: "描述排行"
    t.integer "service_rank_percent", comment: "服务排行"
    t.integer "logistics_rank_status", comment: "物流排行状态"
    t.integer "desc_rank_status", comment: "描述排行状态"
    t.integer "service_rank_status", comment: "服务排行状态"
    t.integer "shop_id", null: false, comment: "关联店铺"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_dsrs_on_id"
  end

  create_table "goods", force: :cascade do |t|
    t.string "name", comment: "商品名称"
    t.string "spu_id", comment: "商品编码"
    t.string "sales_num", comment: "商品销量"
    t.integer "goods_comments_count"
    t.string "comments_total_num"
    t.integer "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spu_id"], name: "index_goods_on_spu_id"
  end

  create_table "goods_comments", force: :cascade do |t|
    t.string "customer_name", comment: "买家昵称"
    t.string "comment", comment: "评论内容"
    t.datetime "time", comment: "评论时间"
    t.integer "good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_goods_comments_on_id"
  end

  create_table "goods_images", force: :cascade do |t|
    t.string "url", comment: "图片链接"
    t.integer "good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mall_services", force: :cascade do |t|
    t.string "name", null: false, comment: "服务名称"
    t.integer "good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_mall_services_on_name"
  end

  create_table "pdd_web_spider_settings", force: :cascade do |t|
    t.string "url", null: false, comment: "网页地址"
    t.integer "port", default: 80, comment: "端口"
    t.integer "retry_limit", comment: "重试次数"
    t.string "proxy", comment: "代理服务器"
    t.string "cookies", comment: "cookies"
    t.string "log_path", comment: "日志文件名"
    t.boolean "status", default: true, comment: "服务开关: 开启才会抓取"
    t.integer "user_id", null: false, comment: "用户ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_pdd_web_spider_settings_on_url"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", comment: "电商平台名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_platforms_on_name", unique: true
  end

  create_table "probe_settings", force: :cascade do |t|
    t.string "url", null: false, comment: "RSS地址"
    t.integer "port", default: 80, comment: "端口"
    t.integer "retry_limit", comment: "重试次数"
    t.string "proxy", comment: "代理服务器"
    t.string "log_path", comment: "日志文件名"
    t.boolean "status", default: true, comment: "服务开关: 开启才会抓取"
    t.integer "user_id", null: false, comment: "用户ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_probe_settings_on_url"
  end

  create_table "rss_feeds", force: :cascade do |t|
    t.string "title", comment: "文章标题"
    t.string "description", comment: "文章描述"
    t.string "author", comment: "作者"
    t.datetime "pub_date", comment: "发布时间"
    t.string "link", comment: "连接地址"
    t.integer "rss_probe_history_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rss_probe_failure_histories", force: :cascade do |t|
    t.string "status", comment: "运行状态"
    t.string "reason", comment: "失败原因"
    t.string "detail", comment: "详细原因"
    t.integer "probe_setting_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_rss_probe_failure_histories_on_id"
  end

  create_table "rss_probe_histories", force: :cascade do |t|
    t.string "title", comment: "RSS源标头"
    t.string "description", comment: "RSS源描述"
    t.datetime "last_build_date", comment: "RSS列表最近创建时间"
    t.string "link", comment: "连接地址"
    t.integer "probe_setting_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.integer "vendor_id", comment: "平台店铺ID"
    t.string "shop_name", comment: "店铺名称"
    t.string "shop_url", comment: "店铺链接"
    t.string "sales_num", comment: "销售量"
    t.string "goods_num", comment: "商品数量"
    t.integer "platform_id", null: false, comment: "关联电商平台"
    t.integer "pdd_web_spider_setting_id", null: false, comment: "关联设置"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_shops_on_id"
    t.index ["vendor_id"], name: "index_shops_on_vendor_id"
  end

  create_table "skus", force: :cascade do |t|
    t.string "skuid", comment: "平台SKU编码"
    t.string "spec", comment: "规格名称"
    t.integer "normal_price", comment: "正常价"
    t.integer "group_price", comment: "团购价"
    t.integer "good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skuid"], name: "index_skus_on_skuid"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: ""
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
