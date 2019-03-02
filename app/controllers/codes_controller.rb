class CodesController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
    @types = Type.all
    @brands = Brand.all
    @roles = Role.all
    @states = State.all
    @situations = Situation.all
  end

end
