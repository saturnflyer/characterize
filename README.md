# Characterize

Make your models behave in special ways.

## Usage

```ruby
class UsersController < ApplicationController
  characterize :user

  def show
  end
end

module AdministratedUser
  def edit_link
    link_to('Edit', admin_user_path)
  end
end

module StandardUser
  def edit_link
    ""
  end
end
```

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
