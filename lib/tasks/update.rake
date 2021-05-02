namespace :tianluo do
  desc 'git pull'
  task :git_pull do
    cmd = 'git pull'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc 'sudo bundle update'
  task :bundle_update do
    cmd = 'sudo bundle update'
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
  task :update => [:git_pull, :bundle_update, :migrate] do
  end
end
