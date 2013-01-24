require 'spec_helper'

describe Manage::LiveSearchesController do
  let!(:item1) {FactoryGirl.create :item, description: 'Ring with one hidden diamond', name: 'secret treasure'}
  let!(:item2) {FactoryGirl.create :item, description: 'Ring with diamonds', name: 'no secret, just bling'}
  let!(:item3) {FactoryGirl.create :item, description: 'Toering', name: 'treasure in the sand'}

  context 'by id' do
    it 'finds a valid id' do
      get :show, id: 1

      json = JSON.parse(response.body)
      json['items'].length.should == 1
      json['items'][0]['pretty_id'].should == item1.pretty_id
    end

    it 'does not find an invalid id' do
      get :show, id: 23412525

      json = JSON.parse(response.body)
      json['items'].length.should == 0
    end
  end

  it 'finds by description' do
    get :show, id: 'diamond'

    json = JSON.parse(response.body)
    json['items'].length.should == 2
    json['items'].map {|item| item['description']}.should include(item1.description)
    json['items'].map {|item| item['description']}.should include(item2.description)
  end

  it 'finds by name' do
    get :show, id: 'treasure'

    json = JSON.parse(response.body)
    json['items'].length.should == 2
    json['items'].map {|item| item['name']}.should include(item1.name)
    json['items'].map {|item| item['name']}.should include(item3.name)
  end
end
