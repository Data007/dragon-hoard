require 'spec_helper'
require 'rake'

describe 'Full name as a single string, split into first_name and last_name' do
  before do
    @user = FactoryGirl.create :user
    @user.first_name = nil
    @user.last_name = nil
    @user.set(:name, "Bryan Denslow")
    @user.save!
    @user.reload
  end

  context 'with a User' do
    it 'seperates the first name and last name' do
      @user.first_name.should_not be
      @user.last_name.should_not be

      execute_rake('name.rake', 'seperate_name_to_first_and_last_names')

      @user.reload
      @user.first_name.should == 'Bryan'
      @user.last_name.should == 'Denslow'
    end
  end
end
