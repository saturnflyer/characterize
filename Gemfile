source 'https://rubygems.org'

# Specify your gem's dependencies in characterize.gemspec
gemspec

group :test do
  gem "sqlite3", :platform => [:ruby, :mswin, :mingw]
  gem "jdbc-sqlite3", :platform => :jruby
  gem 'rails'
  gem 'minitest-spec-rails'
  gem 'rubinius-coverage', platform: :rbx
  gem 'coveralls', require: false
  gem 'simplecov'
end