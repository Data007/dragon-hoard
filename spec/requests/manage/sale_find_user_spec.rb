require 'spec_helper'

describe 'Manage Sales' do
  let!(:employee) {FactoryGirl.create :user, role: 'employee'}
  context 'after a pin is entered' do
    before do
      @user = FactoryGirl.create :user_with_phone_address, first_name: 'Dragonhoard'
      visit manage_path
      click_link 'Sale'
      pin_login employee.pin
    end

    context 'requires a user' do
      it 'finds a user' do
        fill_in 'query', with: @user.first_name
        click_button 'find user'

        page.should have_content(@user.full_name)

        click_link @user.full_name

        current_path.should == edit_manage_sale_path(Order.first)
      end
    end
  end
end
