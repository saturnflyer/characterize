require 'test_helper'

describe UsersController do
  it 'renders views with extra features from characters' do
    get :show, id: '1'
    assert_template :show
    assert_select 'a', 'm( O.O )m'
  end
end
