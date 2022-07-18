require 'test_helper'

describe UsersController do
  def user
    users(:amy)
  end
  it 'renders views with extra features from default characters' do
    get :show, params: { id: user.id }
    assert_template :show
    assert_select 'a', 'm( O.O )m'
  end

  it 'uses configured standard features' do
    get :show, params: { id: user.id }
    assert_template :show
    assert_select 'p', 'hello'
  end

  it 'renders objects with extra features from specified characters' do
    get :edit, params: { id: user.id }
    assert_equal "Yay! Special title", response.body
  end

  it 'works with a different class' do
    get :show, params: { id: user.id }
    assert_select 'div', 'Widget: it works!'
  end
end
