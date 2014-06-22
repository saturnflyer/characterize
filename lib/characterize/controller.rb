require 'characterize/feature_controls'

module Characterize
  module Controller
    def self.included(klass)
      klass.extend(::Characterize::ControllerMacros)
    end
    
    private

    def characterize(obj, *mods)
      obj.__set_view__(view_context).cast_as(*mods)
      obj
    end

    def characters_for_action(object_name, action_name)
      if self.respond_to?("#{object_name}_#{action_name}_characters") && action_methods.include?(action_name.to_s)
        Array(self.send("#{object_name}_#{action_name}_characters"))
      else
        self.send("default_#{object_name}_characters")
      end
    end

    def self.view_features
      [::Characterize::FeatureControls]
    end
  end
  
  module ControllerMacros
    
    private
    
    def characterize(*options)
      object_name = options.shift
      actions_hash = options.last

      default_characters = actions_hash.delete(:default) || ["::#{Converter.new(object_name).to_constant_name}Character"]

      characterize_item = Converter.new(object_name)
      mod = Module.new
      mod.module_eval %{
        def #{object_name}
          return @#{object_name} if defined?(@#{object_name})
          @#{object_name} = characterize(load_#{object_name}, *characters_for_action(:#{object_name}, action_name))
        end

        def load_#{object_name}
          #{characterize_item.to_constant_name}.find(params[:id])
        end

        def default_#{object_name}_characters
          [#{default_characters.map(&:to_s).join(', ')}]
        end
      }
      actions_hash.each_pair do |action_name, characters|
        mod.module_eval %{
          def #{object_name}_#{action_name}_characters
            [#{characters.map(&:to_s).join(', ')}]
          end
        }
      end
      self.const_set(characterize_item.to_constant_name + 'ControllerMethods', mod)
      include mod
      self.send(:helper_method, object_name)
    end
    
    class Converter
      def initialize(string)
        @string = string.to_s
      end
      
      def to_object_name
        to_path.split('/').last
      end
      
      def to_path
        # TODO: get platform-specific path delimiter
        @string.gsub('::','/').gsub(/([A-Z])/){ "_#{$1.downcase}" }.gsub(/^_|\/_/,'/').sub(/^\//,'')
      end
      
      def to_constant_name
        @string.gsub(/(?:^|_)([a-z])/){ $1.upcase }.gsub('/','::')
        # TODO: get platform-specific path delimiter
      end
    end
  end
end