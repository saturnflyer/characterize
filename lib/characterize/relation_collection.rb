# frozen_string_literal: true

require "direction"

module Characterize
  class RelationCollection < Collection
    Collection.register(self, ActiveRecord::Relation)
    extend Direction

    # Defined before safe_command/query so these names are excluded from the
    # auto-generated delegators (see Collection.safe_command) rather than
    # redefining them.
    def not(...)
      reset_collection collection.where.not(...)
      self
    end

    def limit(...)
      reset_collection collection.limit(...)
      self
    end

    def offset(...)
      reset_collection collection.offset(...)
      self
    end

    safe_command ActiveRecord::QueryMethods, receiver: :collection
    query ActiveRecord::Calculations.instance_methods => :collection
  end
end
