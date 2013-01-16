require 'spec_helper'

describe Manage::Sales::LineItemsController do
  before do
    @sale     = FactoryGirl.create :sale
    @employee = FactoryGirl.create :user
    page.set_rack_session manage_user_id: @employee.id
  end

  context 'with an existing item' do
    let!(:item) {FactoryGirl.create :item}

    it 'creates a line_item' do
      post :create, sale_id: @sale.id, line_item: {
        item_id: item.id,
        description: item.description,
        price: item.price,
        quantity: 1
      }

      @sale.reload

      @sale.line_items.length.should == 1
      line_item = @sale.line_items.first

      line_item.description.should == item.description
      line_item.price.should       == item.price
      line_item.quantity.should    == 1
      line_item.item.should        == item
    end

    context 'with a line item' do
      let!(:line_item) {
        @sale.line_items.create(
          item_id: item.id,
          description: item.description,
          price: item.price,
          quantity: 1
        )
      }

      it 'updates a line_item' do
        @sale.line_items.find(line_item.id).price.should == item.price

        post :update, sale_id: @sale.id, id: line_item.id, line_item: {
          price: 3545650.56
        }

        @sale.reload
        @sale.line_items.find(line_item.id).price.should_not == item.price
        @sale.line_items.find(line_item.id).price.should == 3545650.56
      end

      it 'refunds a line_item'

      it 'removes a line_item' do
        @sale.line_items.should include(line_item)
        delete :destroy, sale_id: @sale.id, id: line_item.id

        @sale.reload
        @sale.line_items.should_not include(line_item)
      end
    end
  end

  context 'with a quick item' do
    it 'creates a line_item'
    it 'updates a line_item'
    it 'refunds a line_item'
    it 'removes a line_item'
  end
end
