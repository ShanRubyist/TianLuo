class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['SITE_NAME']} <#{ENV['EMAIL_FROM_ADDRESS']}>"

  layout 'mailer'
end
