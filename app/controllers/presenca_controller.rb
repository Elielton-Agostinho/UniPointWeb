class PresencaController < ApplicationController
  require 'time'
  ENV["TZ"] = "America/Sao_Paulo"
  def create
    puts params['id_chamada']

    require 'http'

    response = HTTP.post("http://localhost:5000/fecharChamada", :form => {'id_chamada' => params['id_chamada']})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    puts response.body

    redirect_to "/professor/index"
  end
end
