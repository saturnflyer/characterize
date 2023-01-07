class WidgetsController < ApplicationController
  characterize :widget
  def show
  end

  def load_widget
    Widget.new
  end
end
