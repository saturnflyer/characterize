# Characterize

Make your models behave in special ways without wrapping them.

Characterize is built on top of [Casting](https://github.com/saturnflyer/casting) and makes it easy to get going in Rails.

[![Build Status](https://travis-ci.org/saturnflyer/characterize.png?branch=master)](https://travis-ci.org/saturnflyer/characterize)
[![Code Climate](https://codeclimate.com/github/saturnflyer/characterize.png)](https://codeclimate.com/github/saturnflyer/characterize)
[![Coverage Status](https://coveralls.io/repos/saturnflyer/characterize/badge.png)](https://coveralls.io/r/saturnflyer/characterize)
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

## Atering the Settings

Characterize will automatically look for modules using the "Character" suffix in it's name. But you can change this if you like.

Just create an initializer which will change the setting when your Rails application boots:

```ruby
Characterize.module_suffix = 'Details'
```

With the above change, using `characterize :user` in your controller, it will attempt to load `UserDetails` instead of `UserCharacter`. This will apply for your *entire* application; if you only want to override the suffix in some places, just specify the module you want in your controller.


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
