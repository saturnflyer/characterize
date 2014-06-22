#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.ruby_opts = ["-w"]
  t.verbose = true
end

task :setup_db do |task|
  system("cd test/internal && RAILS_ENV=test bundle exec rake db:reset")
end
Rake::Task[:test].enhance [:setup_db]

task :default => :test