class LogoutController < ApplicationController
  def index
    session.delete(:user)

    redirect_to '/home/index'
  end
end
