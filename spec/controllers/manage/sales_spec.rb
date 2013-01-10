require 'spec_helper'

=begin
  This is an API test spec.
  The point is to use javascript to access, list, and update all sales records.
=end

describe Manage::SalesController do
  it 'denies me without authorization' do
    get :index
    response.code.should == '401'
  end

  it 'authorizes with a valid token' do
    user    = FactoryGirl.create :user
    session = ApiSession.authorize(user.pin)

    get :index, token: session.token
    response.code.should == '200'
  end

  context 'authorized' do
    before do
      @user = FactoryGirl.create :user
      @session = ApiSession.authorize(@user.pin)
    end

    it 'creates a new sale'do
      post :create, token: @session.token, order: {staging_type: 'sale'}
      response.code.should == '200'
      
      json = JSON.parse(response.body)
      json['order'].should be
      json['order']['_id'].should be
      json['order']['staging_type'].should == 'sale'
      json['order']['location'].should == 'instore'
    end

    context 'with sales' do
      it 'lists all sales'
      it 'finds a sale'
      it 'updates a sale'
      it 'refunds a sale'
      it 'cancels a sale'
      it 'deletes a sale'
    end
  end
end
