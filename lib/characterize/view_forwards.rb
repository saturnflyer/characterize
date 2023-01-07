require 'forwardable'
module Characterize
  module ViewForwards
    extend Forwardable
  
    # Find all view helper modules
    action_view_helpers = ActionView::Helpers::constants.map{|name|
      ActionView::Helpers.const_get(name) 
    }.select{|const|
      const.is_a?(Module)
    }

    # Forward view helper module methods to the view object
    delegate [*action_view_helpers.map(&:instance_methods).flatten.uniq] => :__view__

    # Forward URL helper module methods to the view object
    delegate [*Rails.application.routes.url_helpers.instance_methods] => :__view__
  end
end
