require 'spec_helper'

=begin
  This is an API test spec.
  The point is to use javascript to access, list, and update all sales records.
=end

describe Manage::SessionsController do
  let!(:user) {FactoryGirl.create :user}

  it 'returns an invalid session with an invalid pin' do
    post :create, pin: '123'
    response.code.should == '401'
    
    json = JSON.parse(response.body)
    json['message'].match(/Unauthorized/).should be
  end

  it 'returns a valid session with a valid pin' do
    post :create, pin: user.pin
    response.code.should == '200'
    
    json = JSON.parse(response.body)
    json['user'].should be
    json['user']['first_name'].should be
    json['user']['last_name'].should be
    json['user']['email'].should be
    json['token'].should be
  end
end
