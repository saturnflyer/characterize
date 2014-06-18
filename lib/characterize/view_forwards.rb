require 'forwardable'
module Characterize
  module ViewForwards
    extend Forwardable
  
    delegate [*ActionView::Helpers.constants.map{ |name| 
      ActionView::Helpers.const_get(name) 
    }.map(&:instance_methods).flatten] => :__view__
  end
end