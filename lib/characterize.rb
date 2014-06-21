require "characterize/version"
require "characterize/controller"
require "casting"
require 'characterize/railtie' if defined?(::Rails)

module Characterize
  def self.included(klass)
    klass.class_eval {
      include Casting::Client
      delegate_missing_methods
    }
  end
  
  def view
    @view
  end
  
  def __set_view__(obj)
    @view = obj
    self
  end
end