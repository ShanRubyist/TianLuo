# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, ENV['PATH']
set :output, 'log/whenever.log'

every 1.day, at: ['9:00 am'] do
  runner "RssQueueJob.perform_later", environment: :development
end

every 1.day, at: ['10:00 am'] do
  runner "WebSpiderQueueJob.perform_later", environment: :development
end

every 1.day, at: ['11:00 am'] do
  runner "KeywordsJob.perform_later", environment: :development
end

every :monday, at: ['9:00 am'] do
  runner "WeeklySummaryJob.perform_later", environment: :development
end

every 1.month, at: ['9:00 am'] do
  runner "MonthlySummaryJob.perform_later", environment: :development
end
