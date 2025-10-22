source "https://rubygems.org"

# Ruby version
ruby "3.3.7"

# Core Rails
gem "rails", "~> 8.0.0"
gem "pg", "~> 1.1"
gem "puma", ">= 6.0"
gem "propshaft" # Rails 8 default asset pipeline (replaces sprockets)
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "redis", ">= 5.0" # For Action Cable and caching
gem "bootsnap", require: false
gem "thruster" # Rails 8 HTTP/2 proxy

# Styling & Front-end
gem "bootstrap", "~> 5.2"
gem "autoprefixer-rails"
gem "font-awesome-sass", "~> 6.1"
gem "simple_form", github: "heartcombo/simple_form"
gem "sassc-rails"
gem "prawn" # PDF generation

# Authentication
gem "devise"

# Platform-specific gems
gem "tzinfo-data", platforms: %i[mswin mswin64 mingw x64_mingw jruby]

# File uploads
gem "roo"

# Development and Test group
group :development, :test do
  gem 'faker'
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 7.0'
  gem 'factory_bot_rails'
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw]
  
  # Security & Code Quality
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

# Development-only gems
group :development do
  gem "web-console" # Console on exception pages
end

# Test-only gems
group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
