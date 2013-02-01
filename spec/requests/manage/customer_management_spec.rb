require 'spec_helper'

describe 'Manage Customers' do
  let!(:employee) {FactoryGirl.create :user, role: 'employee'}

  context 'create a user' do
    before do
      visit manage_path
      click_link 'Users'
    end

    it 'creates a user' do
      click_link 'Add a User'
      current_path.should == new_manage_user_management_path
      soap
      fill_in 'user_first_name', with: 'Bryan'
      fill_in 'user_last_name', with: 'Denslow'
      fill_in 'user_addresses_attributes_0_address_1', with: '2235 S 33 1/2 Rd'
      fill_in 'user_addresses_attributes_0_address_1', with: 'Cadillac'
      fill_in 'user_addresses_attributes_0_address_1', with: '49601'
      select  'Michigan', from: 'customer_state' 
      fill_in 'user_phone_number', with: '2318783353'
      fill_in 'user_email', with: 'bryan@deepwoodsbrigade.com'
      fill_in 'user_anniversary', with: '12/15/12'
      select  '6.5', from: 'customer_ring_size'
      click_button 'Create User'

      User.count.should == 2
      User.where(email: 'bryan@deepwoodsbrigade.com').count.should == 1

    end
  end
end
