require 'spec_helper'

describe 'Manage Quick Sale' do
  let!(:employee) {FactoryGirl.create :user, role: 'employee'}

  context 'with a quick sale', js: true do
    before do
      visit manage_path
      click_link 'Quick Sale'
      pin_login employee.pin

      fill_in 'line-item-summary', with: 'ID1 Diamond ring'
      fill_in 'line-item-price', with: '23'
      click_button 'add'
    end

    it 'adds a customer' do
      click_link 'Checkout'

      page.should have_content '23.0'

      click_link 'Lookup Customer'
    end
  end
end
