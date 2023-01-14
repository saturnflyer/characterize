module Characterize
  module FeatureControls
    
    # Enumerate a collection with the given modules and block casting
    # each object with the modules and uncasting the object afterward.
    #
    # Examples:
    #
    #   def each_favorite(&block)
    #     each_with_features(favorites, FavoriteMod, &block)
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
    # The value of the method call will be yielded to the block
    #
    # Examples:
    #
    #   <%= user.with(:favorites, :p, class: 'favorites-details') %>
    #   <%- user.with(:favorites) do |favorites| %>
    #     <p class="favorites-details">
    #       My Favorite Things: <%= favorites.join(', ') %>
    #     </p>
    #   <%- end -%>
    #   <%= user.with(:favorites, :p, class: "whatever", without: "Oops! No favorites!")
    #
    def with(method_name, tag_name=nil, **options, &block)
      without_option = options.delete(:without)
      method_value = self.public_send(method_name)

      display_value = method_value.then do |method_value|
        if with_conditions(method_name, method_value)
          method_value
        else
          without_option
        end
      end

      capture_content = block || ->(method_value=nil) do
        __view__.concat(__view__.content_tag(tag_name, display_value, options))
      end

      __view__.capture(method_value, &capture_content)
    end
    
    # Conditionally render content for the object when the attribute is NOT present.
    #
    # Pass in a method name and a block to render.
    #
    # The value of the method call will be yielded to the block
    #
    # Examples:
    #
    #   <%- user.without(:favorites) do |favorites| %>
    #     <p class="favorites-details none">
    #       There are no favorites here. You had <%= favorites %>
    #     </p>
    #   <%- end -%>
    #   <% user.without(:favorites, :p, value: 'No favorites!')
    #   <% user.without(:favorites, :p, value: "You should have favorites", with: "You DO have favorites!")
    #
    def without(method_name, tag_name=nil, value: nil, **options, &block)
      with_option = options.delete(:with)
      method_value = self.public_send(method_name)

      display_value = method_value.then do |method_value|
        if with_conditions(method_name, method_value)
          with_option
        else
          value
        end
      end

      capture_content = (block || ->(method_value = nil) do
        __view__.concat(__view__.content_tag(tag_name, display_value, options))
      end)

      __view__.capture(method_value, &capture_content)
    end
    
    # Used to override behavior of with for the case of special attributes
    def with_conditions(_method_name, computed_value)
      !computed_value.nil? && computed_value != '' && computed_value != false
    end
  end
end
