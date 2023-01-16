# frozen_string_literal: true

module Characterize
  class ObjectSet
    def initialize(object_name, **hash)
      @object_name = object_name
      @hash = hash
    end
    attr :object_name

    def dig(action_name, *_ignored)
      if @hash.key?(action_name.to_sym)
        Array(defaults + action_characters(action_name)).compact
      else
        defaults
      end
    end

    def object_class_name
      @object_name.to_s.classify
    end

    def object_character_name
      "#{object_class_name}#{Characterize.module_suffix}"
    end

    def object_character
      return @object_character if defined?(@object_character)
      @object_character = begin
        Object.const_get(object_character_name)
      rescue
        nil
      end
    end

    def defaults
      Array(
        Characterize.standard_features + @hash.fetch(:default, []) + [object_character]
      ).flatten.compact.uniq
    end

    def action_object_character_name(action_name)
      "#{action_name.to_s.classify}#{object_character_name}"
    end

    def action_character(action_name)
      Object.const_get(action_object_character_name(action_name))
    rescue
      nil
    end

    def action_characters(action_name)
      Array(@hash.fetch(action_name.to_sym, [action_character(action_name)])).compact
    end
  end
end
