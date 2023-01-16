# frozen_string_literal: true

require "characterize/feature_set"

module Characterize
  module Controller
    def self.included(klass)
      klass.extend(::Characterize::ControllerMacros)
      klass.helper_method(:characterize)
    end

    private

    # Apply character modules to the given object.
    # This will use either the provided modules or if none are provided, the
    # configured characters for the current controller action.
    def characterize(obj, *mods)
      object_name = obj.class.name.to_s.underscore
      features = (!mods.empty?) ? mods : characters_for_action(object_name, action_name)
      obj.__set_characterize_view__(view_context).cast_as(*features)
      obj
    end

    def characters_for_action(object_name, action_name)
      self.class.characterize_features.dig(object_name, action_name)
    end
  end

  module ControllerMacros
    def self.attach_module(klass, name, &block)
      mod = Module.new(&block)
      klass.const_set(name, mod)
      klass.include mod

      mod
    end

    def characterize_features
      @characterize_features ||= FeatureSet.new
    end

    private

    # Generate methods that will load and cast your object with the specified behaviors
    def characterize(object_name, load_with: "load_#{object_name}", **actions_hash, &block)
      characterize_features.add(object_name, **actions_hash)

      mod = ControllerMacros.attach_module(
        self,
        "#{object_name.to_s.classify}ControllerMethods",
        &block
      )

      unless method_defined?(load_with)
        # def load_user
        #   User.find(params[:id])
        # end
        mod.module_eval <<~MOD, __FILE__, __LINE__ + 1
          def #{load_with}
            #{object_name.to_s.classify}.find(params[:id])
          end
        MOD
      end

      unless method_defined?(object_name)
        # def user
        #   return @user if instance_variable_defined?(@user) && !@user.nil?
        #
        #   @user = characterize(load_user, *characters_for_action(:user, action_name))
        # end
        mod.module_eval <<~MOD, __FILE__, __LINE__ + 1
          def #{object_name}
            return @#{object_name} if defined?(@#{object_name})

            @#{object_name} = characterize(#{load_with}, *characters_for_action(__method__, action_name))
          end
        MOD
      end

      send(:helper_method, object_name)
    end

    def characterize_each(name, load_with: "load_#{name}", **actions_hash, &block)
      characterize_features.add(name, **actions_hash)

      constant_name = name.to_s.singularize.classify
      mod = ControllerMacros.attach_module(
        self,
        "#{constant_name}CollectionControllerMethods",
        &block
      )

      unless method_defined?(load_with)
        # def load_users
        #   User.all
        # end
        mod.module_eval <<~MOD, __FILE__, __LINE__ + 1
          def #{load_with}
            #{constant_name}.all
          end
        MOD
      end

      unless method_defined?(name)
        # def users
        #   return @users if @users.is_a?(Characterize::Collection)
        #
        #   @users = Characterize::Collection.for(load_users, *characters_for_action(:users, action_name))
        # end
        mod.module_eval <<~MOD, __FILE__, __LINE__ + 1
          def #{name}
            return @#{name} if @#{name}.is_a?(Characterize::Collection) && !@#{name}.nil?

            @#{name} = Characterize::Collection.for(#{load_with}, *characters_for_action(__method__, action_name))
          end
        MOD
      end

      send(:helper_method, name)
    end
  end
end
