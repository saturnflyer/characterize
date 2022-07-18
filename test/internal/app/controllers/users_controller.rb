class UsersController < ApplicationController
  characterize :user, default: [SpecialCharacter],
                      edit: [EditUserCharacter]
  
  def show; end
  def edit
    render :plain => user.editing_title
  end
  
end
