class UsersController < ApplicationController
  Characterize.standard_features = Characterize.builtin_standard_features + [StandardCharacter]

  characterize :user, default: [SpecialCharacter],
                      edit: [EditUserCharacter]
  characterize :widget
  
  def show; end
  def edit
    render :plain => user.editing_title
  end

  def load_widget
    Widget.new
  end
end
