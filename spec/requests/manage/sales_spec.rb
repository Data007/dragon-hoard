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

      it 'finds employee with a valid pin' do
        fill_in 'Employee ID', with: employee.pin
        click_button 'Enter'

        current_path.should == edit_manage_sale_path(Sale.first.id)
      end

      it 'creates a sale' do 
        current_path.should == edit_manage_sale_path(Sale.first)
        page.should have_content("Order #{Sale.first.id}")
      end
    end
  end
end
