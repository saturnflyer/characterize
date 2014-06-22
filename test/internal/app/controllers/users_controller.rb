class UsersController < ApplicationController
  characterize :user, default: [SpecialCharacter]
  
  def show; end
  
end