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

ActiveRecord::Schema.define(version: 2020_04_12_024443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
