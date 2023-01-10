require 'rails/generators'
require "rails/generators/base"

module Characterize
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Characterize initializer for your application."

      def copy_initializer
        template "initializer.rb", "config/initializers/characterize.rb"
      end
    end
  end
end
