require 'spec_helper'

describe 'Managing Sales' do
  let!(:employee) {FactoryGirl.create :user, role: 'employee'}

  context 'create a sale' do
    before do
      visit manage_path
      click_link 'Sale'
    end

    context 'requires an employee pin' do
      before do
        current_path.should == new_manage_session_path
      end

      it 'rejects invalid pins' do
        fill_in 'Employee ID', with: '3242535'
        click_button 'Enter'

        page.should have_content('Unauthorized')
      end

      context 'with a valid pin' do
        before do
          fill_in 'Employee ID', with: employee.pin
          click_button 'Enter'
        end

        it 'creates a sale' do 
          current_path.should == edit_manage_sale_path(Order.first)
          page.should have_content("Order #{Order.first.pretty_id}")
        end
      end
    end
  end
end
