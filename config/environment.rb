# frozen_string_literal: true

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# https://sendgrid.com/docs/for-developers/sending-email/rubyonrails/#configure-actionmailer-to-use-sendgrid
ActionMailer::Base.smtp_settings = {
  address: "smtp.sendgrid.net",
  authentication: :plain,
  enable_starttls_auto: true,
  port: 456,
  domain: ENV["SENDGRID_HOST"],
  from: ENV["SENDGRID_BOT_EMAIL"],
  password: ENV["SENDGRID_PASSWORD"],
  user_name: ENV["SENDGRID_USERNAME"],
}
