# frozen_string_literal: true

module Characterize
  class RelationCollection < Collection
    Collection.register(self, ActiveRecord::Relation)

    def method_missing(method_name, ...)
      if @collection.respond_to?(method_name)
        @collection.send(method_name, ...)
      end
      self
    end

    def respond_to_missing?(name, include_all)
      @collection.respond_to?(name, include_all)
    end
  end
end
