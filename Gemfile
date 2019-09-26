# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

gem "bootsnap", ">= 1.1.0", require: false
gem "coffee-rails", "~> 4.2"
gem "html2slim"
gem "jbuilder", "~> 2.5"
gem "mysql2", ">= 0.4.4", "< 0.6.0"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.3"
gem "sass-rails"
gem "slim-rails"
gem "uglifier", ">= 1.3.0"
gem "devise", "~> 4.7.1"
gem "bootstrap", "~> 4.3.1"
gem "jquery-rails"
gem "redis"
gem "chartjs-ror", "~> 3.6.4"
gem "groupdate", "~> 4.1.2"
gem "config"
gem 'font-awesome-sass', '~> 5.11.2'

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "pry-rails"
  gem "faker", "~> 2.3"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop", "~> 0.74.0", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "chromedriver-helper"
  gem "selenium-webdriver"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
