source "https://rubygems.org"

# Ruby version
ruby "3.1.2"

# Core Rails
gem "rails", "~> 7.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "redis", ">= 4.0.1" # For Action Cable in production
gem "bootsnap", require: false

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

# Development and Test group
group :development, :test do
  gem 'faker'
  gem "dotenv-rails"
  gem "rspec-rails", "~> 5.0.0"
  gem 'factory_bot_rails', '~> 6.0'
  gem "debug", platforms: %i[mri mswin mswin64 mingw x64_mingw]
end

# Development-only gems
group :development do
  gem "web-console" # Console on exception pages
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

# Test-only gems
group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
