require 'spec_helper'

=begin
  This is an API test spec.
  The point is to use javascript to access, list, and update all sales records.
=end

describe Manage::SalesController do
  it 'denies me without authorization' do
    get :index, format: :js
    response.code.should == '401'
  end

  it 'authorizes with a valid pin' do
    user    = FactoryGirl.create :user
    session = ApiSession.authorize(user.pin)

    get :index, format: :js, token: session.token
    response.code.should == '200'

    json = JSON.parse(response.body)
    json['user'].should be
    json['user']['first_name'].should be
    json['user']['last_name'].should be
    json['user']['email'].should be
    json['token'].should be
  end

  context 'authorized' do
    before do
      @user = FactoryGirl.create :user
      @session = ApiSession.authorize(@user.pin)
    end

    it 'creates a new sale'do
      # TODO: post sale creation stuff
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
