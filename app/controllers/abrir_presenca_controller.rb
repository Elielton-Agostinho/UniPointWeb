class AbrirPresencaController < ApplicationController
  require 'time'
  ENV["TZ"] = "America/Sao_Paulo"
  def create
    puts params['professor']

    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/abrirChamada", :form => {'professor' => session[:user],'disciplina' => params['id_disciplina']})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    puts response.body

    redirect_to "/professor/index"
  end
end
