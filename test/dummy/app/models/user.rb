class User < ApplicationRecord
  def widgets
    [
      Widget.new(flag: true),
      Widget.new(flag: false)
    ]
  end
end
