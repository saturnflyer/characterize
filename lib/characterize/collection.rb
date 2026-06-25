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

      # Return an object handling the collection's type
      #
      # This will select the first matching class from which the collection's
      # class inherits.
      #
      def for(collection, *behaviors)
        klass = registry.find { |key, _value|
          collection.class < key
        }&.last || self
        klass.new(collection, *behaviors)
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
      @behaviors = behaviors
      reset_collection(collection)
    end
    attr :casted_enum, :collection, :behaviors

    delegated_methods = (Enumerator.instance_methods(false) + Enumerable.instance_methods(false)).uniq - [:object_id, :inspect]
    def_delegators :casted_enum, *delegated_methods

    def inspect
      %(#<#{self.class} #{object_id}>)
    end

    private

    def reset_collection(collection)
      @casted_enum = enum(collection, *behaviors)
      @collection = collection
    end
  end
end
require "characterize/relation_collection"
