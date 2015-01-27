require 'forwardable'
module Characterize
  module ViewForwards
    extend Forwardable
  
    action_view_helpers = ActionView::Helpers::constants.map{|name|
      ActionView::Helpers.const_get(name) 
    }.select{|const|
      const.is_a?(Module)
    }

    delegate [*action_view_helpers.map(&:instance_methods).flatten.uniq] => :__view__

    delegate [*Rails.application.routes.url_helpers.instance_methods] => :__view__
  end
end