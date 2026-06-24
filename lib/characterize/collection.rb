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
          # Direction builds a "#{name}_result" delegator via Forwardable,
          # which evals the name as Ruby source. Names that aren't plain
          # identifiers -- bang (preload!), predicate (exists?), setter
          # (select_values=) or operator methods -- would produce invalid
          # identifiers like "preload!_result" and raise SyntaxError under
          # Ruby 4.0. Keep only plain-identifier methods.
          names = names.select { |name| name.match?(/\A[a-zA-Z_][a-zA-Z0-9_]*\z/) }
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

    def_delegators :casted_enum, *(Enumerator.instance_methods(false) - [:object_id])
    def_delegators :casted_enum, *(Enumerable.instance_methods(false))

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
