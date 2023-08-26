[![Maintainability](https://api.codeclimate.com/v1/badges/62169bb8e53f6d2721a9/maintainability)](https://codeclimate.com/github/ShanRubyist/TianLuo/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/62169bb8e53f6d2721a9/test_coverage)](https://codeclimate.com/github/ShanRubyist/TianLuo/test_coverage)
[![Build Status](https://travis-ci.org/ShanRubyist/TianLuo.svg?branch=master)](https://travis-ci.org/ShanRubyist/TianLuo)
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/ShanRubyist/TianLuo/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/ShanRubyist/TianLuo/tree/master)
[![Coverage Status](https://coveralls.io/repos/github/ShanRubyist/TianLuo/badge.svg)](https://coveralls.io/github/ShanRubyist/TianLuo)
[![security](https://hakiri.io/github/ShanRubyist/TianLuo/master.svg)](https://hakiri.io/github/ShanRubyist/TianLuo/master)
![Alt](https://repobeats.axiom.co/api/embed/53b9bd22627cee5ce3694fb2cd940a4603ec7caa.svg "Repobeats analytics image")

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Deploy
### 方式1: 直接部署

* 安装依赖包
```
sudo bundle
```

* 执行数据库迁移  
```
rails db:migrate
```

* 设定 *config/schedule* 定时任务  
```
whenever --update-cron
crontab -l
```

* 启动 *sidekiq* 服务  
```
bundle exec sidekiq
```

* 启动 *webpack* 或者 生成 *assets*  
```
./bin/webpack-dev-server
rails assets:precompile
```

### 方式2: docker 部署
```
docker-compose up -d
```