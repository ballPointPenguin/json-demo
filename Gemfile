# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.1"

gem "rails", "~> 6.0.3", ">= 6.0.3.1"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.4.2", require: false
gem "devise_token_auth"
gem "jsonapi-utils", "~> 0.7.3"
gem "pg", ">= 0.18", "< 2.0"
gem "pry-rails"
gem "puma", "~> 4.1"
gem "rack-cors"
gem "sendgrid-ruby"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "rspec-rails", "~> 4.0.0"
  gem "rubocop-rails_config"
  gem "simplecov"
end

group :development do
  gem "brakeman"
  gem "guard-rspec"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end
