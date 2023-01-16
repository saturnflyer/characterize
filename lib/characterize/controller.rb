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

      mod.module_eval {
        # def user
        #   return @user if instance_variable_defined?(@user) && !@user.nil?
        #
        #   @user = characterize(load_user, *characters_for_action(:user, action_name))
        # end
        unless method_defined?(object_name)
          define_method(object_name) do
            ivar_name = "@#{__method__}"
            object = instance_variable_get(ivar_name)
            return object if instance_variable_defined?(ivar_name) && !object.nil?

            instance_variable_set(ivar_name,
              characterize(send(load_with), *characters_for_action(__method__, action_name)))
          end
        end

        # def load_user
        #   User.find(params[:id])
        # end
        unless method_defined?(load_with)
          define_method(load_with) do
            Object.const_get(object_name.to_s.classify).find(params[:id])
          end
        end
      }

      send(:helper_method, object_name)
    end

    def characterize_collection(collection_name, load_with: "load_#{collection_name}", **actions_hash, &block)
      characterize_features.add(collection_name, **actions_hash)

      constant_name = collection_name.to_s.singularize.classify
      mod = ControllerMacros.attach_module(
        self,
        "#{constant_name}CollectionControllerMethods",
        &block
      )

      mod.module_eval {
        # def users
        #   return @users if @users.is_a?(Characterize::Collection)
        #
        #   @users = Characterize::Collection.for(load_users, *characters_for_action(:users, action_name))
        # end
        unless method_defined?(collection_name)
          define_method(collection_name) do
            ivar_name = "@#{collection_name}"
            collection = instance_variable_get(ivar_name)
            return collection if collection.is_a?(Characterize::Collection)

            instance_variable_set ivar_name, Characterize::Collection.for(
              send(load_with),
              *characters_for_action(__method__, action_name)
            )
          end
        end

        # def load_users
        #   User.all
        # end
        unless method_defined?(load_with)
          define_method(load_with) do
            Object.const_get(constant_name).all
          end
        end
      }

      send(:helper_method, collection_name)
    end
  end
end
