require "forwardable"
module Characterize
  class Collection
    extend Forwardable

    def self.for(collection, *behaviors)
      if collection.class < ActiveRecord::Relation
        ::Characterize::Collection::Relation
      else
        self
      end.new(collection, *behaviors)
    end

    class Relation < self
      def method_missing(method_name, ...)
        if @collection.respond_to?(method_name)
          @collection.send(method_name, ...)
        else
          super
        end
      end
    end

    include Casting::Enum
    def initialize(collection, *behaviors)
      @casted_enum = enum(collection, *behaviors)
      @collection = collection
      @behaviors = behaviors
    end
    attr :casted_enum

    def_delegators :casted_enum, *(Enumerator.instance_methods - [:enum])

    def method_missing(name, ...)
      if casted_enum.respond_to?(name, true)
        casted_enum.send(name, ...)
      else
        super
      end
    end

    def respond_to_missing?(name, include_all)
      casted_enum.respond_to?(name, include_all)
    end
  end
end
