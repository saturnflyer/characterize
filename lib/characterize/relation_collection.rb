# frozen_string_literal: true

require "direction"

module Characterize
  class RelationCollection < Collection
    Collection.register(self, ActiveRecord::Relation)
    extend Direction

    command ActiveRecord::QueryMethods.instance_methods => :collection
    query ActiveRecord::Calculations.instance_methods => :collection
  end
end
