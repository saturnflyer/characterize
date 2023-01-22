# frozen_string_literal: true

require "direction"

module Characterize
  class RelationCollection < Collection
    Collection.register(self, ActiveRecord::Relation)
    extend Direction

    safe_command ActiveRecord::QueryMethods, receiver: :collection
    query ActiveRecord::Calculations.instance_methods => :collection

    def not(...)
      collection.where.not(...)
      self
    end
  end
end
