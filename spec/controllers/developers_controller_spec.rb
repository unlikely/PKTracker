require 'spec_helper'

describe DevelopersController do
  describe 'index' do
    render_views

    it 'works' do
      get :index
      response.should be_success
    end
  end

  describe 'create' do
    it 'redirects back to new on validation failure' do
      post :create, developer: {}
      response.should be_success
      response.should render_template 'new'
    end

    it 'redirects to show on success' do
      post :create, developer: Factory.attributes_for(:developer, name: 'usar')
      ev = Developer.last
      response.should redirect_to developer_path(ev.id)
    end
  end

  describe 'show' do
    render_views

    it 'works' do
      ev = Factory :developer, name: 'usar'
      get :show, id: ev.to_param
      response.should be_success
    end
  end

  describe 'update' do
    it 'works' do
      ev = Factory :developer, name: 'usar', points_accepted: 3
      put :update, id: ev.to_param, developer: { name: 'user', points_accepted: 12, last_question: '2011-12-5 19:45:00 -0500' }
      ev.reload
      ev.name.should == 'user'
      ev.points_accepted.should == 12
    end

    it 'redirects to show on success' do
      ev = Factory :developer, name: 'usar'
      put :update, id: ev.to_param
      response.should redirect_to developer_path(ev.id)
    end

    it 're-renders edit on validation fail' do
      ev = Factory :developer, name: 'usar'
      put :update, id: ev.to_param, developer: { name: ''}
      response.should render_template 'edit'
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
