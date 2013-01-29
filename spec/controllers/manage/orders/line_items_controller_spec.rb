require 'spec_helper'

describe Manage::Orders::LineItemsController do
  before do
    @order    = FactoryGirl.create :order, staging_type: 'sale'
    @employee = FactoryGirl.create :user
    page.set_rack_session manage_user_id: @employee.id
  end

  context 'with an existing item' do
    let!(:item) {FactoryGirl.create :item}

    it 'creates a line_item' do
      post :create, order_id: @order.id, line_item: {
        item_id: item.id,
        description: item.description,
        price: item.price,
        quantity: 1
      }

      @order.reload

      @order.line_items.length.should == 1
      line_item = @order.line_items.first

      line_item.description.should == item.description
      line_item.price.should       == item.price
      line_item.quantity.should    == 1
      line_item.item.should        == item
    end

    context 'with a line item' do
      let!(:line_item) {
        @order.line_items.create(
          item_id: item.id,
          description: item.description,
          price: item.price,
          quantity: 1
        )
      }

      it 'updates a line_item' do
        @order.line_items.find(line_item.id).price.should == item.price

        post :update, order_id: @order.id, id: line_item.id, line_item: {
          price: 3545650.56
        }

        @order.reload
        @order.line_items.find(line_item.id).price.should_not == item.price
        @order.line_items.find(line_item.id).price.should == 3545650.56
      end

      it 'refunds a line_item'

      it 'removes a line_item' do
        @order.line_items.should include(line_item)
        delete :destroy, order_id: @order.id, id: line_item.id

        @order.reload
        @order.line_items.should_not include(line_item)
      end
    end
  end
end
