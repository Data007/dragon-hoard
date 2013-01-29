class PagesController < ApplicationController
  def home
    @items = Item.published.listable
  end
  
  def bad_route
    render :template => "responses/404"
  end
end
