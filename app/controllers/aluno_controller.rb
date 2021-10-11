class AlunoController < ApplicationController
  def index
    if session[:user].nil? == true or session[:user] == ''
      session.delete(:user)

      redirect_to '/login/index'
    end
  end
end
