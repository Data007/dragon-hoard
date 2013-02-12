class Manage::AppraisalsController < ManageController
  before_filter :force_pin
  before_filter :find_appraisal, except: [:new, :create]

  def new
    order = Order.create(staging_type: 'appraisal')
    redirect_to edit_manage_appraisal_path(order)
  end

  def edit
    render text: 'finish me'
  end
private
  def find_appraisal
    id = params[:sale_id] ? params[:sale_id] : params[:id]
    @order = Order.find(id)
  end
end
