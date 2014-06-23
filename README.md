# Characterize

Make your models behave in special ways.

Characterize is built on top of [Casting](https://github.com/saturnflyer/casting) and makes it easy to get going in Rails.

## Usage

```ruby
class UsersController < ApplicationController
  characterize :user

  def show
  end
end
# the above sets a helper_method of 'user' and loads UserCharacter

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

## Installation

Add this line to your application's Gemfile:

    gem 'characterize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install characterize

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
