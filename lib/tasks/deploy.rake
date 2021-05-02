namespace :tianluo do
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

  desc 'run sidekiq & wepacker-dev-server'
  task :deploy => [:sidekiq, :webpack] do
  end
end
