class CodesController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.rol == 1
      @users = User.all
      @types = Type.all
      @brands = Brand.all
      @roles = Role.all
      @states = State.all
      @situations = Situation.all
    else
      @mensaje = "Seccion exclusiva para administrador"
    end
  end

end
