require 'spec_helper'

describe 'Manage Sales' do
  let!(:employee) {FactoryGirl.create :user, role: 'employee'}
  context 'after a pin is entered' do
    before do
      @user = FactoryGirl.create :user, first_name: 'Dragonhoard'
      visit manage_path
      click_link 'Sale'
    end

    context 'requires a user' do
      it 'finds a user' do
        fill_in 'query', with: 'DragonHoard'
        click_button 'find user'

        page.should have_content('DragonHoard')

        click_link 'Select'
      end
    end
  end
end
