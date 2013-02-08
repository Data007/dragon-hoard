require 'spec_helper'

describe Manage::CustomersController do
  before do
    @current_user = FactoryGirl.create :user_with_phone_address, role: 'admin'
    page.set_rack_session manage_user_id: @current_user.id
  end

  context 'with a customer' do
    let!(:customer) {FactoryGirl.create :user_with_phone_address}

    it 'updates the customer' do
      customer.first_name.should_not == 'frank'
      put :update, user: {first_name: 'frank'}

      response.status.should == 200
      response.body.should have_content('Your changes have been saved')
      customer.reload
      customer.first_name.should == 'frank'
    end

    it 'fails to update the customer'
  end
end
