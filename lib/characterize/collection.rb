require "forwardable"
module Characterize
  class Collection
    extend Forwardable

    class << self
      def registry
        @registry ||= {}
      end

      # Register a collection class to manage the given type
      def register(klass, type)
        registry[type] = klass
      end

      def for(collection, *behaviors)
        registry.fetch(collection.class, self).new(collection, *behaviors)
      end
    end

    include Casting::Enum
    def initialize(collection, *behaviors)
      @casted_enum = enum(collection, *behaviors)
      @collection = collection
      @behaviors = behaviors
    end
    attr :casted_enum

    def_delegators :casted_enum, *(Enumerator.instance_methods(false) - [:object_id])

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
