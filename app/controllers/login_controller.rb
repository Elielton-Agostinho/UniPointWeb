class LoginController < ApplicationController
  def index
    if session[:user]
      redirect_to '/dashboard_aluno/index'
    end
  end

  def create
    require 'http'
    matricula = params[:email]
    senha = params[:senha]

    response = HTTP.post("https://unipointapi.herokuapp.com/login", :form => {'matricula' => matricula, 'senha' => senha })
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    puts r['result']

    if r['result']
      session[:user] = matricula
      redirect_to '/dashboard_aluno/index'
    else
      @resposta = 'Erro: Login ou senha estão incorretos'
      render 'login/index'
    end

  end
end
