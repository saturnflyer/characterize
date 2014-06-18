require "characterize/version"
require "characterize/controller"
require "casting"

module Characterize
  def self.included(klass)
    klass.class_eval {
      include Casting::Client
      delegate_missing_methods
    }
  end
  
  def viewable?
    !!view
  end
  
  def view
    @view
  end
  
  def __set_view__(obj)
    @view = obj
    self
  end
end

require 'active_record'
class ActiveRecord::Base
  include Characterize
end

require 'action_controller'
class ActionController::Base
  include Characterize::Controller
end