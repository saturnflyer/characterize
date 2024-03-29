require "characterize/version"
require "characterize/controller"
require "characterize/feature_controls"
require "casting"
require "characterize/collection"
require "characterize/railtie" if defined?(::Rails)

module Characterize
  def self.included(klass)
    klass.class_eval {
      include Casting::Client
      delegate_missing_methods
    }
  end

  def __view__
    @characterize_view
  end

  def __set_characterize_view__(obj)
    @characterize_view = obj
    self
  end

  def self.module_suffix
    @characterize_suffix ||= "Character"
  end

  def self.module_suffix=(val)
    @characterize_suffix = val
  end

  def self.standard_features
    @standard_features ||= builtin_standard_features.dup
  end

  def self.standard_features=(mods_array)
    @standard_features = mods_array
  end

  def self.builtin_standard_features
    [::Characterize::FeatureControls].freeze
  end

  def self.register_collection(klass, type)
    Collection.register(klass, type)
  end
end
