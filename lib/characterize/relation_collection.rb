# frozen_string_literal: true

require "direction"

module Characterize
  class RelationCollection < Collection
    Collection.register(self, ActiveRecord::Relation)
    extend Direction

    safe_command ActiveRecord::QueryMethods, receiver: :collection
    query ActiveRecord::Calculations.instance_methods => :collection

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
  end
end
