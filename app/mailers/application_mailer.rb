class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_SENDER", "apexestatesales@gmx.com")
  layout "mailer"
end
