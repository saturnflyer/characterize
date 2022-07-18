require 'test_helper'

describe UsersController do
  it 'renders views with extra features from default characters' do
    user = User.create!(name: "Jim")
    get :show, params: { id: user.id }
    assert_template :show
    assert_select 'a', 'm( O.O )m'
  end

  it 'renders objects with extra features from specified characters' do
    user = User.create!(name: "Jim")
    get :edit, params: { id: user.id }
    assert_equal "Yay! Special title", response.body
  end
end
