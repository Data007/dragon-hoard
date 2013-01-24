class Manage::LiveSearchesController < ApplicationController
  def show
    items = LiveSearch.query(params[:id])
    render json: {items: items}.to_json
  end
end
