# frozen_string_literal: true

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# https://sendgrid.com/docs/for-developers/sending-email/rubyonrails/#configure-actionmailer-to-use-sendgrid
ActionMailer::Base.smtp_settings = {
  address: ENV["SMTP_ADDRESS"],
  authentication: :plain,
  enable_starttls_auto: true,
  port: ENV["SMTP_PORT"],
  domain: ENV["DOMAIN_NAME"],
  from: ENV["SENDGRID_BOT_EMAIL"],
  password: ENV["SENDGRID_PASSWORD"],
  user_name: ENV["SENDGRID_USERNAME"],
}
