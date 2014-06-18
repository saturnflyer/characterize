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
  end
  
  module ControllerMacros
    
    private
    
    def characterize(*symbols_strings_or_classes)
      options = symbols_strings_or_classes.empty? ? [self] : symbols_strings_or_classes
      options.map do |identifier|
        characterize_item = Converter.new(identifier)
        object_name = characterize_item.to_object_name
        mod = Module.new
        mod.module_eval %{
          def #{object_name}
            @#{object_name} ||= characterize(load_#{object_name}, *characterize_#{object_name}_modules)
          end
          
          def load_#{object_name}
            #{characterize_item.to_constant_name}.find(params[:id])
          end
          
          def characterize_#{object_name}_modules
            [::Characterize::FeatureControls] + #{object_name}_modules
          end
          
          def #{object_name}_modules
            [#{object_name}_default_character]
          end
          
          def #{object_name}_default_character
            #{Converter.new(object_name).to_constant_name}Character
          end
        }
        self.const_set(characterize_item.to_constant_name + 'ControllerMethods', mod)
        include mod
        self.send(:helper_method, object_name)
      end
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