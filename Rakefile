require "bundler/gem_tasks"

task :console do
  require 'irb'
  require 'irb/completion'
  require File.expand_path("spec/dummy/config/environment")
  require 'simple_bootstrap_form'
  ARGV.clear
  IRB.start
end
