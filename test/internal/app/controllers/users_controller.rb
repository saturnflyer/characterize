class UsersController < ApplicationController
  characterize :user
  
  def show; end
  
  def user_modules
    [SpecialCharacter]
  end
  
end