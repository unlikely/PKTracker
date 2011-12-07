require 'spec_helper'

describe DevelopersController do
  describe 'index' do
    it 'works' do
      get :index
      response.should be_success
    end
  end

  describe 'create' do
    it 'redirects to show' do
      post :create, ev: Factory(:developer, name: 'usar')
    end
  end

  describe 'show' do
    it 'works' do
      ev = Factory :developer, name: 'usar'
      get :show, id: ev.to_param
      response.should be_success
    end
  end

  describe 'update' do
    it 'redirects to show' do
      ev = Factory :developer, name: 'usar'
      put :update, id: ev.to_param
      response.should redirect_to developer_path(ev.id)
    end
  end

  describe 'destroy' do
    it 'redirects to index' do
      ev = Factory :developer, name: 'usar'
      delete :destroy, id: ev.to_param
      response.should redirect_to developers_path
    end
  end
end
