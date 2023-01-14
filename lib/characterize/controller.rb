module Characterize
  module Controller
    def self.included(klass)
      klass.extend(::Characterize::ControllerMacros)
      klass.helper_method(:characterize)
    end

    private

    # Apply character modules to the given object.
    # This will use either the provided modules or if none are provided, the
    # configured default characters for the current controller action.
    def characterize(obj, *mods)
      object_name = obj.class.name.to_s.underscore
      features = (!mods.empty?) ? mods : characters_for_action(object_name, action_name)
      obj.__set_characterize_view__(view_context).cast_as(*features)
      obj
    end

    def characters_for_action(object_name, action_name)
      defaults = if respond_to? "default_#{object_name}_features"
        send("default_#{object_name}_features")
      else
        []
      end

      specific_characters = if respond_to?("#{object_name}_#{action_name}_features") && action_methods.include?(action_name.to_s)
        Array(send("#{object_name}_#{action_name}_features"))
      else
        []
      end

      defaults.concat(specific_characters)
    end
  end

  module ControllerMacros
    private

    # Generate methods that will load and cast your object with the specified behaviors
    def characterize(object_name, **actions_hash)
      object_constant_name = object_name.to_s.gsub(/(?:^|_)([a-z])/) { $1.upcase }.gsub("/", "::")
      default_features = actions_hash.delete(:default) || ["::#{object_constant_name}#{Characterize.module_suffix}"]

      mod = Module.new
      mod.module_eval <<~MOD, __FILE__, __LINE__ + 1
        def #{object_name}
          return @#{object_name} if defined?(@#{object_name})
          @#{object_name} = characterize load_#{object_name}, *characters_for_action(:#{object_name}, action_name)
        end

        def load_#{object_name}
          #{object_constant_name}.find(params[:id])
        end

        def default_#{object_name}_features
          @default_#{object_name}_features ||= (Characterize.standard_features + [#{default_features.map(&:to_s).join(", ")}]).uniq
        end
      MOD

      actions_hash.each_pair do |action_name, characters|
        mod.module_eval <<~MOD, __FILE__, __LINE__ + 1
          def #{object_name}_#{action_name}_features
            (default_#{object_name}_features + [#{characters.map(&:to_s).join(", ")}]).uniq
          end
        MOD
      end
      const_set(object_constant_name + "ControllerMethods", mod)
      include mod
      send(:helper_method, object_name)
    end

    def characterize_collection(collection_name, **actions_hash)
      object_constant_name = collection_name.to_s.singularize.gsub(/(?:^|_)([a-z])/) { $1.upcase }.gsub("/", "::")
      default_features = actions_hash.delete(:default) || ["::#{object_constant_name}#{Characterize.module_suffix}"]

      mod = Module.new
      mod.module_eval <<~MOD, __FILE__, __LINE__ + 1
        def #{collection_name}
          return @#{collection_name} if @#{collection_name}.is_a?(Characterize::Collection)
          @#{collection_name} = Characterize::Collection.for load_#{collection_name}, *characters_for_action(:#{collection_name}, action_name)
        end

        def load_#{collection_name}
          #{object_constant_name}.all
        end

        def default_#{collection_name}_features
          @default_#{collection_name}_features ||= (Characterize.standard_features + [#{default_features.map(&:to_s).join(", ")}]).uniq
        end
      MOD

      actions_hash.each_pair do |action_name, characters|
        mod.module_eval <<~MOD, __FILE__, __LINE__ + 1
          def #{collection_name}_#{action_name}_features
            (default_#{collection_name}_features + [#{characters.map(&:to_s).join(", ")}]).uniq
          end
        MOD
      end

      const_set(object_constant_name + "CollectionControllerMethods", mod)
      include mod
      send(:helper_method, collection_name)
    end
  end
end
