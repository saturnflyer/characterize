# frozen_string_literal: true

require "characterize/object_set"

module Characterize
  class FeatureSet
    def initialize
      @object_rules = {}
    end

    def add(object_name, **actions_hash)
      @object_rules[object_name] = ObjectSet.new(object_name, **actions_hash)
    end

    def dig(*args)
      @object_rules.dig(*args)
    end
  end
end
