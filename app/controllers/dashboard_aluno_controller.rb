class DashboardAlunoController < ApplicationController
  def index
    if session[:user].nil? == true or session[:user] == ''
      session.delete(:user)

      redirect_to '/login/index'
    else

    end
  end
end
