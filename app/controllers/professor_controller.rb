class ProfessorController < ApplicationController
  def index
    if session[:user].nil? == true or session[:user] == ''
      session.delete(:user)

      redirect_to '/login/index'
    else
      getUsuario(session[:user])
    end
  end

  def getUsuario(matricula)
    require 'http'

    response = HTTP.post("http://localhost:5000/getProfessor", :form => {'matricula' => matricula})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]

    email = retorno["EMAIL"].split('unifor')
    @email = email[0] + '...'

    nome = retorno["NOME"].split(' ')
    @primeiroNome = nome[0]

    @nome = nome[0] + ' ' + nome[1]
  end


end
