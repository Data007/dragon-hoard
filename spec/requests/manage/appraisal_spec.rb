require 'spec_helper'

describe 'Manage Appraisals' do
  let!(:employee) {FactoryGirl.create :user, role: 'employee'}

  context 'creates an appraisal' do
    before do
      visit manage_path
      click_link 'Appraisals'
      pin_login employee.pin
    end

    it 'creates an appraisal without a picture' do
      fill_in 'appraisal_notes', with: '14k Gold Diamond Ring'
      fill_in 'appraisal_price', with: '12345'
      click_button 'Save'

      Appraisal.count.should == 1
    end
  end
end
