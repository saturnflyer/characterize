# frozen_string_literal: true

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
        (
          registry.find { |key, _value|
            collection.class < key
          }.last || self
        ).new(collection, *behaviors)
      end

      def safe_command(*classes, receiver:)
        standard = [:object_id, :__send__] +
          Enumerator.instance_methods(false) +
          Enumerable.instance_methods(false)

        classes.each do |klass|
          names = klass.instance_methods - standard - instance_methods(false)
          command names => :collection
        end
      end
    end

    include Casting::Enum
    def initialize(collection, *behaviors)
      @casted_enum = enum(collection, *behaviors)
      @collection = collection
      @behaviors = behaviors
    end
    attr :casted_enum, :collection, :behaviors

    def_delegators :casted_enum, *(Enumerator.instance_methods(false) - [:object_id])
    def_delegators :casted_enum, *(Enumerable.instance_methods(false))
  end
end
require "characterize/relation_collection"
