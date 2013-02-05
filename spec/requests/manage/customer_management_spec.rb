require 'spec_helper'

describe 'Manage Customers' do
  let!(:employee) {FactoryGirl.create :user, role: 'employee'}

  context 'create a user' do
    before do
      visit manage_path
      click_link 'Customers'
    end

    it 'creates a user' do
      click_link 'Add a User'
      current_path.should == new_manage_customer_path

      fill_in 'user_first_name', with: 'Bryan'
      fill_in 'user_last_name', with: 'Denslow'
      fill_in 'user_addresses_attributes_0_address_1', with: '2235 S 33 1/2 Rd'
      fill_in 'user_addresses_attributes_0_city', with: 'Cadillac'
      fill_in 'user_addresses_attributes_0_postal_code', with: '49601'
      select  'MI', from: 'user_addresses_attributes_0_province' 
      fill_in 'user_phones_attributes_0_number', with: '2318783353'
      fill_in 'user_email', with: 'bryan@deepwoodsbrigade.com'
      fill_in 'user_email_confirmation', with: 'bryan@deepwoodsbrigade.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      fill_in 'user_anniversary', with: '12/15/12'
      fill_in 'user_ring_size', with: '13.5'
      click_button 'Save'

      User.customers.count.should == 1
      current_path.should == edit_manage_customer_path(User.customers.first)
    end
  end

  context 'with a User' do
    before do
      @customer1 = FactoryGirl.create :user_with_phone_address, role: 'customer', first_name: 'bryan'
      @customer2 = FactoryGirl.create :user_with_phone_address, role: 'customer', first_name: 'mike'
      visit manage_path 
      click_link 'Customers'
    end

    it 'views the customers' do
      page.should have_content(@customer1.first_name)
      page.should have_content(@customer1.last_name)
      page.should have_content(@customer2.first_name)
      page.should have_content(@customer1.last_name)
    end

    it 'edits the user' do
      within("#user_#{@customer1.id}") do
        click_link 'edit'
      end

      current_path.should == edit_manage_customer_path(@customer1)

      fill_in "user_first_name", with: 'George'
      fill_in 'user_email', with: 'bryan@hello.com'
      fill_in 'user_email_confirmation', with: 'bryan@hello.com'

      click_button 'Save'
      current_path.should == edit_manage_customer_path(@customer1)

      User.where(first_name: 'Bryan').count.should == 0
      User.where(first_name: 'George').count.should == 1
    end

    it 'deletes a user' do
      within("#user_#{@customer1.id}") do
        click_link 'delete'
      end

      current_path.should == manage_customers_path
      User.where(first_name: 'bryan').count.should == 0
    end
  end
end
