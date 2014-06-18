module Characterize
  module FeatureControls
    
    # Enumerate a collection with the given modules and block casting
    # each object with the modules and uncasting the object afterward.
    #
    # Examples:
    #
    #   def each_favorite(&block)
    #     each_with_feature(favorites, FavoriteMod, &block)
    #   end
    #
    #   <%- user.each_favorite do |favorite| %>
    #     <%= favorite.special_feature %>
    #   <%- end -%>
    #
    def each_with_features(collection, *mods, &block)
      collection.lazy.each do |obj|
        obj.cast_as(*mods)
        block.call(obj)
        obj.uncast(mods.size)
      end
    end
    
    # Conditionally render content for the object.
    #
    # Pass in a method name for content and either of:
    #  1. options for Rails' content_tag
    #  2. a block to render
    #
    # Examples:
    #
    #   <%= user.with(:favorites, :p, class: 'favorites-details') %>
    #   <%- user.with(:favorites) do %>
    #     <p class="favorites-details">
    #       My Favorite Things: <%= user.favorites.join(', ') %>
    #     </p>
    #   <%- end -%>
    #
    def with(method_name, *tag_name_or_options)
      value = self.public_send(method_name)
      if with_conditions(method_name, value)
        if block_given?
          yield
        else
          tag_name, options = *tag_name_or_options
          view.content_tag(tag_name, value, options)
        end
      else
        without_option = tag_name_or_options.last.fetch(:without){ '' }
        if without_option.respond_to?(:call)
          without(method_name, &without_option)
        else
          view.concat(without_option)
        end
      end
    end
    
    # Conditionally render content for the object when the attribute is NOT present.
    #
    # Pass in a method name and a block to render.
    #
    # Examples:
    #
    #   <%- user.without(:favorites) do %>
    #     <p class="favorites-details none">
    #       There are no favorites here.
    #     </p>
    #   <%- end -%>
    #
    def without(method_name, &block)
      value = self.public_send(method_name)
      if !with_conditions(method_name, value)
        yield
      end
    end
    
    # Used to override behavior of with for the case of special attributes
    def with_conditions(method_name, computed_value)
      !computed_value.nil? && computed_value != '' && computed_value != false
    end
  end
end