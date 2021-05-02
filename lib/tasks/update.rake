namespace :tianluo do
  desc 'git pull'
  task :git_pull do
    cmd = 'git pull'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc 'sudo bundle'
  task :bundle do
    cmd = 'sudo bundle'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc 'rails db:migrate'
  task :migrate do
    cmd = 'rails db:migrate'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc 'project update'
  task :update => [:git_pull, :bundle, :migrate] do
  end
end
