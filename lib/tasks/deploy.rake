desc 'run sidekiq & wepacker-dev-server'
task :deploy => ['deploy:whenever', 'deploy:sidekiq', 'deploy:webpack']

namespace :deploy do
  desc '设定 config/schedule 定时任务'
  task :whenever do
    cmd = 'whenever --update-cron'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc '启动 sidekiq 服务'
  task :sidekiq do
    cmd = 'bundle exec sidekiq'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc '启动 webpack-dev-server'
  task :webpack do
    cmd = './bin/webpack-dev-server &'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end
end
