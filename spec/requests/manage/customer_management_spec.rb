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

    context 'finger sizes' do
      before do
        visit edit_manage_customer_path(@customer1)
      end

      it 'adds a finger size' do
        @customer1.fingers.count.should == 0

        click_link 'Add Ring Size'
        fill_in 'finger_name', with: 'pinky'
        fill_in 'finger_size', with: '3'
        click_button 'Save'

        @customer1.fingers.count.should == 1
        @customer1.fingers.first.name.should == 'pinky'
        @customer1.fingers.first.size.should == '3'

        current_path.should == edit_manage_customer_path(@customer1)
      end

      context 'with a finger' do
        before do
          @finger = @customer1.fingers.create name: 'pinky', size: '3'
          visit edit_manage_customer_path(@customer1)
        end

        it 'updates a finger size' do
          within("#finger_#{@customer1.fingers.first.id}") do
            fill_in 'Name', with: 'middle'
            fill_in 'Size', with: '12'
          end

          click_button 'Save'

          @finger.reload
          @finger.name.should == 'middle'
          @finger.size.should == '12'
        end
      end
    end

    context 'it adds phone numbers' do
      before do
        visit edit_manage_customer_path(@customer1)
        @customer1.phones = nil
      end

      it 'adds a phone number' do
        @customer1.phones.count.should == 0

        click_link 'Add Phone Number'
        fill_in 'phone_number', with: '2319204567'
        click_button 'Save'

        @customer1.phones.count.should == 1
        @customer1.phones.first.number.should == '2319204567'

        current_path.should == edit_manage_customer_path(@customer1)
      end

      context 'with a phone' do
        before do
          @phone = @customer1.phones.create number: '1234567890'
          visit edit_manage_customer_path(@customer1)
        end

        it 'updates a phone number' do
          within("#phone_#{@phone.id}") do
            fill_in 'Number', with: '0987654321'
          end

          click_button 'Save'

          @phone.reload
          @phone.number.should == '0987654321'
        end

        it 'deletes phone numbers' do
          @customer1.phones.count.should == 1
          within("#phone_#{@phone.id}") do
            click_link 'Delete'
          end

          @customer1.phones.count.should == 0
        end
      end
    end

    context 'it adds addresses' do
      before do
        visit edit_manage_customer_path(@customer1)
        @customer1.addresses = nil
      end

      it 'adds a an address' do
        @customer1.addresses.count.should == 0

        click_link 'Add Address'
        fill_in 'address_address_1', with: '1135 W 37 1/2 Rd'
        fill_in 'address_city', with: 'Cadillac'
        select  'MI', from: 'address_province' 
        fill_in 'address_postal_code', with: '49601'
        click_button 'Save'

        @customer1.reload
        @customer1.addresses.count.should == 1
        @customer1.addresses.first.address_1.should == '1135 W 37 1/2 Rd'

        current_path.should == edit_manage_customer_path(@customer1)
      end

      context 'with a phone' do
        before do
          @address = @customer1.addresses.create address_1: '1234 W 37 1/2 Rd' , city: 'Cadillac', postal_code: '49601', province: 'MI'
          visit edit_manage_customer_path(@customer1)
        end

        it 'updates a address' do
          within("#address_#{@address.id}") do
            fill_in "user_addresses_attributes_0_address_1", with: '2234 S 34 RD'
            fill_in 'user_addresses_attributes_0_city', with: 'Manton'
            fill_in 'user_addresses_attributes_0_postal_code', with: '12345'
          end

          fill_in 'user_email_confirmation', with: "#{@customer1.email}"
          click_button 'Save'

          @address.reload
          @address.address_1.should == '2234 S 34 RD'
          @address.city.should == 'Manton'
          @address.postal_code.should == '12345'
        end

        it 'deletes an address' do
          @customer1.addresses.count.should == 1
          within("#address_#{@address.id}") do
            click_link 'Delete'
          end

          @customer1.reload
          @customer1.addresses.count.should == 0
        end
      end
    end

    it 'views the customers' do
      page.should have_content(@customer1.first_name)
      page.should have_content(@customer1.last_name)
      page.should have_content(@customer2.first_name)
      page.should have_content(@customer2.last_name)
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

    context 'relationships' do
      it 'adds a friend' do
        @customer1.alliances.present?.should_not be

        visit edit_manage_customer_path(@customer1)
        click_link 'Add a Relationship'

        current_path.should == find_manage_customer_alliances_path(@customer1)
        fill_in 'query', with: @customer2.first_name
        click_button 'Search'

        current_path.should == new_manage_customer_alliance_path(@customer1)
        click_link 'link user'

        current_path.should == select_manage_customer_alliance_path(@customer1, @customer2)
        select 'Friend', from: 'alliance_relationship'
        click_button 'Save'

        current_path.should == edit_manage_customer_path(@customer1)
        @customer1.reload
        @customer1.alliances.present?.should be
        @customer1.alliances.friends.map(&:ally).should include(@customer2)
      end

      it 'removes a friend'
    end
  end
end
