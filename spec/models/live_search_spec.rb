require 'spec_helper'

describe LiveSearch do
  context 'live search' do
    let!(:item1) {FactoryGirl.create :item, description: 'Ring with one hidden diamond', name: 'secret treasure'}
    let!(:item2) {FactoryGirl.create :item, description: 'Ring with diamonds', name: 'no secret, just bling'}
    let!(:item3) {FactoryGirl.create :item, description: 'Toering', name: 'treasure in the sand'}

    context 'by id' do
      it 'finds a valid id' do
        items = LiveSearch.query(item1.pretty_id)
        items.length.should == 1
        items.first.should == item1
      end

      it 'does not find an invalid id' do
        items = LiveSearch.query(12342)
        items.length.should == 0
      end
    end

    it 'finds by description' do
      items = LiveSearch.query('diamond')
      items.length.should == 2
      items.should include(item1)
      items.should include(item2)
    end

    it 'finds by name' do
      items = LiveSearch.query('secret')
      items.length.should == 2
      items.should include(item1)
      items.should include(item2)
    end
  end
end
