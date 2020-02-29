source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.1.0", require: false
gem "config"
gem "faraday"
gem "figaro"
gem "jwt"
gem "mysql2", ">= 0.4.4", "< 0.6.0"
gem "puma", "~> 3.12"
gem "rack-cors"
gem "rails", "~> 5.2.3"
gem "rubocop", "~> 0.69.0", require: false

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.8"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "database_cleaner"
  gem "shoulda-matchers"
end

group :production do
  gem "capistrano",         require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-rails",   require: false
  gem "capistrano-rvm",     require: false
  gem "capistrano3-puma",   require: false
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
