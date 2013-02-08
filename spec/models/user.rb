require 'spec_helper'

describe User do
  context 'with a user' do
    before do
      @user = FactoryGirl.create :user
    end

    context 'access pin' do
      subject {@user.pin}
      it {should be}
    end

    it 'validates correct input for emails' do
      @user.update_attributes!(email: 'donald_duck@mickeyscastle.com', email_confirmation: 'donald_duck@mickeyscastle.com')
      @user.email.should == 'donald_duck@mickeyscastle.com'

      ->{@user.update_attributes!(email: 'three', email_confirmation: 'three')}.should raise_error(Mongoid::Errors::Validations)
      @user.reload
      @user.email.should == 'donald_duck@mickeyscastle.com'


      @user.update_attributes!(email: 'bryan@deewoodsbigade.com', email_confirmation: 'bryan@deewoodsbigade.com')
      @user.reload
      @user.email.should == 'bryan@deewoodsbigade.com'

      ->{@user.update_attributes!(email: 'three@universal.pasta.sauce', email_confirmation: 'three@universal.pasta.sauce')}.should raise_error(Mongoid::Errors::Validations)
      @user.reload
      @user.email.should == 'bryan@deewoodsbigade.com'
      
      ->{@user.update_attributes!(email: 'three@', email_confirmation: 'three@')}.should raise_error(Mongoid::Errors::Validations)
      @user.reload
      @user.email.should == 'bryan@deewoodsbigade.com'
    end

    context '#add_alliance' do
      before do
        @user = FactoryGirl.create :user_with_phone_address, gender: 'male'
        @user_ally = FactoryGirl.create :user_with_phone_address, gender: 'male'

        @user.add_alliance({ally_id: @user_ally.id, relationship: 'nephew'})
        @user.reload
        @user_ally.reload
        @user_alliance = @user.alliances.first
        @ally_alliance = @user_ally.alliances.first
      end
      
      it{@user_alliance.relationship.should == 'nephew'}
      it{@ally_alliance.relationship.should == 'uncle'}
    end
  end
end
