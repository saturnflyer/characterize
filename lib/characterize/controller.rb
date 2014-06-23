module Characterize
  module Controller
    def self.included(klass)
      klass.extend(::Characterize::ControllerMacros)
    end
    
    private

    def characterize(obj, *mods)
      obj.__set_characterize_view__(view_context).cast_as(*mods)
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

      object_constant_name = object_name.to_s.gsub(/(?:^|_)([a-z])/){ $1.upcase }.gsub('/','::')
      default_characters = actions_hash.delete(:default) || ["::#{object_constant_name}#{Characterize.module_suffix}"]

      mod = Module.new
      mod.module_eval %{
        def #{object_name}
          return @#{object_name} if defined?(@#{object_name})
          @#{object_name} = characterize(load_#{object_name}, *characters_for_action(:#{object_name}, action_name))
        end

        def load_#{object_name}
          #{object_constant_name}.find(params[:id])
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
      self.const_set(object_constant_name + 'ControllerMethods', mod)
      include mod
      self.send(:helper_method, object_name)
    end
  end
end