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
      current_path.should == new_manage_user_path
      
      fill_in 'user_first_name', with: 'Bryan'
      fill_in 'user_last_name', with: 'Denslow'
      fill_in 'user_addresses_attributes_0_address_1', with: '2235 S 33 1/2 Rd'
      fill_in 'user_addresses_attributes_0_city', with: 'Cadillac'
      fill_in 'user_addresses_attributes_0_postal_code', with: '49601'
      select  'MI', from: 'user_addresses_attributes_0_province' 
      soap
      fill_in 'user_phones_attributes_0_number', with: '2318783353'
      fill_in 'user_email', with: 'bryan@deepwoodsbrigade.com'
      fill_in 'user_email_confirmation', with: 'bryan@deepwoodsbrigade.com'
      fill_in 'user_anniversary', with: '12/15/12'
      select  '6 1/2', from: 'user_ring_size'
      click_button 'Create User'

      current_path.should == manage_users_path

      User.where(role: 'customer').count.should == 1
    end
  end
end
