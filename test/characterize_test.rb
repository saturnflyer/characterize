require 'test_helper'

describe UsersController do
  it 'renders views with extra features from default characters' do
    get :show, id: '1'
    assert_template :show
    assert_select 'a', 'm( O.O )m'
  end

  it 'renders objects with extra features from specified characters' do
    get :edit, id: '1'
    assert_equal "Yay! Special title", response.body
  end
end
