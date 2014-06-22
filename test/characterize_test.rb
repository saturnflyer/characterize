require 'test_helper'

describe UsersController do
  it 'renders views with extra features from characters' do
    get :show, id: '1'
    assert_template :show
  end
end
