class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['SITE_NAME']} <#{ENV['EMAIL_FROM_ADDRESS']}>",
          reply_to: ENV['REPLY_TO']

  layout 'mailer'
end
