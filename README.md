# Characterize

Make your models behave in special ways without wrapping them.

Characterize is built on top of [Casting](https://github.com/saturnflyer/casting) and makes it easy to get going in Rails.

[![Code Climate](https://codeclimate.com/github/saturnflyer/characterize.png)](https://codeclimate.com/github/saturnflyer/characterize)
[![Gem Version](https://badge.fury.io/rb/characterize.png)](http://badge.fury.io/rb/characterize)

## Usage

```ruby
class UsersController < ApplicationController
  characterize :user

  def show
  end
end
# the above sets a helper_method of 'user' and loads UserCharacter

module UserCharacter
  def special_behavior_available_in_the_view
     # ...
  end
end

class UsersController < ApplicationController
  def show
    characterize(user, display_module)
  end

  def display_module
    current_user.can_edit?(user) ? AdministratedUser : StandardUser
  end
end

# use a standard interface in your views but change the character of the object

module AdministratedUser
  def edit_link
    view.link_to('Edit', admin_user_path)
  end
end

module StandardUser
  def edit_link
    ""
  end
end
```

Set special modules to be used for different actions:

```ruby
class UsersController < ApplicationController
  characterize :user, show: [SpecialStuff, StandardStuff],
                      edit: [EditingCharacter],
                      default: [StandardStuff]

  def show
  end
end
```

By default Characterize will look for modules that match the name of your object. So `characterize :user` would apply a `UserCharacter` module (and will blow up if it can't find it.) Or you can override it with the above configuration.

You can also use it to characterize collections:

```ruby
class WidgetsController < ApplicationController
  characterize_collection :widgets, index: [SuperWidgetCharacter]

  def index
  end
end
```

This will create a `widgets` helper method that will return a collection object where enumerable methods will cast the object as the provided modules.

By default these methods will assume a loading method for your records but you can override this:

```ruby
class UsersController < ApplicationController
  characterize :user # creates a `load_user` method
  characterize :user, load_with: :get_a_user

  def get_a_user
    UserRepository.get(params[:user_id])
  end
end
```

## Altering the Settings

### Module names

Characterize will automatically look for modules using the "Character" suffix in it's name. But you can change this if you like.

Just create an initializer which will change the setting when your Rails application boots:

```ruby
Characterize.module_suffix = 'Details'
```

With the above change, using `characterize :user` in your controller, it will attempt to load `UserDetails` instead of `UserCharacter`. This will apply for your *entire* application; if you only want to override the suffix in some places, just specify the module you want in your controller.

### Creating your own standard features

By default Characterize has some helpful features built in. You can use them like this:

```ruby
class UsersController < ApplicationController
  characterize :user, show: [SpecialStuff].concat(Characterize.standard_features)

  def show
  end
end
```

That will load the built-in features from Characterize. But you can change what is considered "standard" in your application.

Set the `standard_features` option in your initializer to whatever you want:

```ruby
original_features = Characterize.standard_features
Characterize.standard_features = [MyAwesomeStuff, ExtraDoodads].concat(original_features)
```

## Installation

Add this line to your application's Gemfile:

    gem 'characterize'

And then execute:

    $ bundle

And finally

    $ rails g characterize:install

Or install it yourself as:

    $ gem install characterize

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
