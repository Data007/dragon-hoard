require 'spec_helper'
require 'digest/sha3'

describe ApiSession do
  let!(:user) {FactoryGirl.create :user}

  it 'does not authorize with an invalid pin' do
    session = ApiSession.authorize('231')
    session.user.should_not be
  end

  it 'authorizes with a valid pin' do
    session = ApiSession.authorize(user.pin)
    session.user.should be
  end

  context 'returning session object' do
    let!(:session) {ApiSession.authorize(user.pin)}

    it 'returns a user' do
      session.user.should be
      session.user.full_name.should == user.full_name
    end

    it 'returns a safe token' do
      session.token.should == Digest::SHA3.hexdigest("#{session.id}#{session.created_at}")
    end
  end
end
