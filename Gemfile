source 'https://rubygems.org'

# Specify your gem's dependencies in characterize.gemspec
gemspec

group :test do
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.rc1', platform: :jruby
  gem 'sqlite3', platform: :ruby
  gem 'rails'
  gem 'minitest-spec-rails'
  gem 'rubinius-coverage', platform: :rbx
  gem 'coveralls', require: false
  gem 'simplecov'
end