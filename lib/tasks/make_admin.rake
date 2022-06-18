namespace :tianluo do
  desc "Promote user to admin status"
  task :make_admin, :email do |task, args|
    if args[:email]
      User.find_by_email(args[:email]).update(role: 'admin')
      puts "User with email #{args[:email]} is now an admin."
    else
      puts "Invalid command, use: rake tianluo:make_admin[email]"
      exit 1
    end
  end
end

