class AbrirPresencaController < ApplicationController
  def create
    puts params['professor']

    require 'http'

    response = HTTP.post("http://localhost:5000/abrirChamada", :form => {'professor' => session[:user],'disciplina' => params['id_disciplina']})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    puts response.body

    redirect_to "/professor/index"
  end
end
