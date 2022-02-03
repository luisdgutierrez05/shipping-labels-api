source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Ruby Version
ruby "3.0.3"

# AASM is a continuation of the acts-as-state-machine rails plugin, built for plain Ruby objects.
gem 'aasm', '~> 5.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use PostgreSQL as the database for Active Record.
gem 'pg', '~> 1.3', '>= 1.3.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.6', '>= 5.6.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.1"

# Resque is a Redis-backed Ruby library for creating background jobs.
gem 'resque', '~> 2.2'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  # Debugging functionality for Ruby
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # rspec-rails is a testing framework for Rails 5+.
  gem 'rspec-rails', '~> 5.1'
end

group :test do
  # Strategies for cleaning databases.
  gem 'database_cleaner', '~> 2.0', '>= 2.0.1'

  # factory_bot_rails provides integration between factory_bot and rails 5.0 or newer.
  gem 'factory_bot_rails', '~> 6.2'

  # Code coverage for Ruby.
  gem 'simplecov', '~> 0.21.2'

  # provides one-liners to test common Rails functionality.
  gem 'shoulda-matchers', '~> 5.1'
end

group :development do
  # Annotates Rails/ActiveRecord Models based on the database schema.
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'

  # Automatic Rails code style checking tool.
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
