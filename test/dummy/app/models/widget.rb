class Widget
  include Characterize

  def initialize(flag: true)
    @flag = flag
  end
  attr :flag

  def name
    "Widget"
  end

  def description
    "This is the description of the #{name}"
  end

  def empty_data
  end
end
