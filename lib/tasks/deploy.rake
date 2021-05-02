namespace :tianluo do
  desc 'bundle exec sidekiq'
  task :sidekiq do
    cmd = 'bundle exec sidekiq'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc './bin/webpack-dev-server &'
  task :webpack do
    cmd = './bin/webpack-dev-server &'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc 'run sidekiq & wepacker-dev-server'
  task :deploy => [:sidekiq, :webpack] do
  end
end
