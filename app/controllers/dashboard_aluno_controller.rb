class DashboardAlunoController < ApplicationController
  def index
    if session[:user].nil? == true or session[:user] == ''
      session.delete(:user)

      redirect_to '/login/index'
    else

      getUsuario(session[:user])

      getDisciplina(session[:user])

      podeMarcar(@id_disciplina)

      getPonto(session[:user],@id_disciplina)

    end
  end

  def create
    puts params['disciplina']

    setPonto(session[:user],params['disciplina'],params['tipo'])

    redirect_to '/dashboard_aluno/index'
  end

  def getUsuario(matricula)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/getAluno", :form => {'matricula' => matricula})
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

  def getDisciplina(matricula)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/getDisciplina", :form => {'matricula' => matricula})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]
    #puts retorno["id_disciplina"]
    #podeMarcar(retorno["id_disciplina"])
    @id_disciplina = retorno["id_disciplina"]
    @disciplina = retorno["NOME"]
    @horario = retorno["COD_DISC"]

  end

  def podeMarcar(disciplina)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/aptoAoPonto", :form => {'disciplina' => disciplina})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]

    if retorno["CHAMADA_ABERTA"] == 'S' then
      @marcacao = true
    else
      @marcacao = false
    end

  end

  def getPonto(matricula,disciplina)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/pontoBatido", :form => {'matricula' => matricula,'disciplina' => disciplina})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]
    puts 'Retorno: '+ retorno["RETORNO"],disciplina
    @tipo = retorno["RETORNO"]
    if retorno["RETORNO"] === "E" then
      @ponto = true
    else
      @ponto = false
    end

  end

  def setPonto(matricula,disciplina,tipo)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/setPonto", :form => {'matricula' => matricula,'disciplina' => disciplina, 'tipo' => tipo})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    #r = JSON.parse(response.body)

    #retorno = r[0]
    @respostaMark = response.body
    #if retorno["PONTO"] == 0 then
    #  @ponto = true
    #else
    #  @ponto = false
    #end

  end

end
