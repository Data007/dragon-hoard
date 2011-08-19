class Admin::ItemsController < AdminController

  before_filter :find_item, :except => [:index, :published]
  
  def show
  end

  def edit
  end

  def update
    if @item.update_attributes(params[:item])
      flash[:notice] = 'The item has been saved'
      redirect_to [:admin, @item]
    else
      flash[:error] = "We couldn't save the item"
      render 'admin/items/edit'
    end
  end

  def destroy
    @item.update_attribute :ghost, true
    redirect_to [:admin, @item]
  end

  def remove
    @item.update_attribute :ghost, true
    redirect_to [:admin, @item]
  end

  def restore
    @item.update_attribute :ghost, false
    redirect_to [:admin, @item]
  end

  def index
    @items = Item.all.paginate(pagination_hash)
  end

  def published
    @items = Item.published.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def current
    @items = Item.listable.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def old
    @items = Item.not_available.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def instore
    @items = Item.listable.unpublished.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def ooak
    @items = Item.oak.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def find
  end

private

  def find_item
    @item      = params[:item_id] ? Item.find(params[:item_id]) : Item.find(params[:id])
    @variation = @item.variations.find(params[:variation_id]) if params[:variation_id]
  end
end