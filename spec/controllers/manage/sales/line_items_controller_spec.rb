require 'spec_helper'

describe Manage::Sales::LineItemsController do
  let!(:sale) {FactoryGirl.create :sale}
  let!(:token) {
    user    = FactoryGirl.create :user
    session = ApiSession.authorize(user.pin)
    session.token
  }

  it 'creates a line item for a sale' do
    post :create, sale_id: sale.pretty_id, line_item: {is_quick_item: true}, token: token
    response.code.should == '200'

    json = JSON.parse(response.body)
    json['line_item']['_id'].should be
  end

  context 'line item for a sale' do
    let!(:line_item) {sale.line_items.create is_quick_item: true, price: 1}

    it 'updates the quantity for a line item' do
      put :update, sale_id: sale.id, id: line_item.id, line_item: {quantity: 2}, token: token
      response.status.should == 200

      json = JSON.parse(response.body)
      json['line_item']['price'].should == line_item.price
      json['line_item']['quantity'].should == 2

      line_item.reload
      line_item.quantity.should == 2
    end

    it 'updates the total for a line item'
    it 'refunds the line item'
    it 'deletes the line item'
  end
end
