# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.1'

gem 'rails', path: './gems/rails'

gem 'ar_lazy_preload', path: './gems/ar_lazy_preload'
gem 'audited', path: './gems/audited'
gem 'devise', path: './gems/devise'
gem 'dotenv'
gem 'fast_blank'
gem 'image_processing'
gem 'lograge'
gem 'motor-admin', path: '../motor'
gem 'mysql2'
gem 'oj'
gem 'pg'
gem 'puma'
gem 'sqlite3'
gem 'webpacker'

group :development, :test do
  gem 'brakeman', require: false
  gem 'byebug'
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'yard', require: false
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'web-console'
end
