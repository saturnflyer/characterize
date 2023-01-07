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
    assert_select 'div', 'Widget true: it works!'
  end

  it 'renders collections with the configured features' do
    get :index
    assert_select 'p', 'Amy in a collection'
  end

  it 'uses feature controls' do
    get :show, params: { id: user.id }
    assert_select 'p.widget-true', 'Widget true yes'
    assert_select 'p.widget-false', 'Widget false yes'
  end
end

describe WidgetsController do
  it 'has access to the with feature control' do
    get :show, params: { id: 1 }
    assert_select 'p.described', 'This is the description of the Widget true'
  end

  it 'can use a block for the with feature control' do
    get :show, params: { id: 1 }
    assert_select 'div.blocky-description', 'Description block!'
  end

  it 'uses the without option in the with feature control' do
    get :show, params: { id: 1 }
    assert_select 'p.missing', "oops! it's missing"
  end

  it 'has access to the without feature control' do
    get :show, params: { id: 1 }
    assert_select 'h1.nope', "You have no data"
  end

  it 'has access to the without feature control' do
    get :show, params: { id: 1 }
    assert_select 'p.missing', "oops! it's missing"
  end

  it 'uses the with option in the without feature control' do
    get :show, params: { id: 1 }
    assert_select 'h1.yup', "You DO have a description"
  end
end
