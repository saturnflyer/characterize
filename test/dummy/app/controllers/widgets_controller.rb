class WidgetsController < ApplicationController
  characterize :widget,
    default: [SpecialCharacter, WidgetCharacter],
    load_with: :make_a_widget

  def show
  end

  def make_a_widget
    Widget.new
  end
end
