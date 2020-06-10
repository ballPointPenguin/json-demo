# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SENDGRID_BOT_EMAIL") { "from@example.com" }
  layout "mailer"
end
