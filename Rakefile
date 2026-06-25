#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"
require "reissue/gem"

Reissue::Task.create :reissue do |task|
  task.version_file = "lib/characterize/version.rb"
  task.fragment = :git
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
  t.ruby_opts = ["-w"]
  t.verbose = true
end

task default: :test
