class RequestsController < ApplicationController
  before_action :authenticate_user!


  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all
    @products = Product.all
  end

  def create

  end

  def new

  end

  def update

  end

  def show

  end

end
