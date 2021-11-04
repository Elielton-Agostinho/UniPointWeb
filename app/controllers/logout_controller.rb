class LogoutController < ApplicationController
  def index
    session.delete(:user)

    redirect_to '/login/index'
  end
end
