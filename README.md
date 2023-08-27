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
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
```

* 安装 SCWS
* [查看 zhparser](https://github.com/amutu/zhparser)
```
apt install -y automake
wget -q -O - http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2 | tar jxf -
cd scws-1.2.3 ;
./configure ; make install
```

* 安装 zhparser
```
git clone https://github.com/amutu/zhparser.git
cd zhparser
apt install postgresql-server-dev-all -y
make && make install
```

* 执行 postgresql 命令
```
su postgres
psql -d db_name -c "CREATE EXTENSION zhparser;CREATE TEXT SEARCH CONFIGURATION testzhcfg (PARSER = zhparser);ALTER TEXT SEARCH CONFIGURATION testzhcfg ADD MAPPING FOR n,v,a,i,e,l WITH simple;"
```

* 安装 yarn
* [yarn install](https://classic.yarnpkg.cn/docs/install#debian-stable)
```
apt install -y nodejs

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn -y

yarn
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

* 启动程序
```
rails server -b 0.0.0.0 -p 3000
```

### 方式2: docker 部署
```
docker-compose up -d
```