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
      Casting::Enum.enum(collection, *mods).each(&block)
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
    def with(method_name, tag_name=nil, **options, &block)
      without_option = options.delete(:without)
      value = self.public_send(method_name).then do |value|
        if with_conditions(method_name, value)
          value
        else
          without_option
        end
      end

      capture_content = block || -> do
        __view__.concat(__view__.content_tag(tag_name, value, options))
      end

      __view__.capture(&capture_content)
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
    #   <% user.without(:favorites, :p, value: 'No favorites!')
    #
    def without(method_name, tag_name=nil, value: nil, **options, &block)
      with_option = options.delete(:with)
      method_value = self.public_send(method_name)
      display_value = value

      if with_conditions(method_name, method_value)
        display_value = with_option
      end

      capture_content = block || -> do
        __view__.concat(__view__.content_tag(tag_name, display_value, options))
      end

      __view__.capture(&capture_content)
    end
    
    # Used to override behavior of with for the case of special attributes
    def with_conditions(_method_name, computed_value)
      !computed_value.nil? && computed_value != '' && computed_value != false
    end
  end
end
