class Manage::SalesController < ManageController
  before_filter :force_pin
  before_filter :find_sale, except: [:new, :create]

  def new
    @sale = Sale.create
    redirect_to [:edit, :manage, @sale]
  end

private
  def find_sale
    id = params[:sale_id] ? params[:sale_id] : params[:id]
    @sale = Sale.find(id)
  end
end
