class Manage::Orders::PaymentsController < Manage::OrdersController
  skip_filter :force_pin
  before_filter :find_order

  def index
  end
end
