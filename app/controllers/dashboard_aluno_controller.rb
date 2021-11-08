class DashboardAlunoController < ApplicationController
  PRODUCAO = 'https://unipointapi.herokuapp.com'
  HOMOLOGACAO = 'http://localhost:5000'
  def index
    if session[:user].nil? == true or session[:user] == ''
      session.delete(:user)

      redirect_to '/login/index'
    else

      getUsuario(session[:user])

      d = DateTime.now
      dia = d.strftime("%A")
      hora = d.strftime("%H")
      horaMin = d.strftime("%H,%M")

      semanaD = {"Monday" => 2,"Tuesday" => 3,"Wednesday" => 4, "Thursday" => 5, "Friday" => 6, "Saturday" => 7}

      turno = ''
      case hora.to_i # a_variable is the variable we want to compare
      when 6..12 then turno = "M"
      when 13..18  then turno = "T"
      when 19..23 then turno = "N"
      end

      periodo = ''
      puts horaMin
      case horaMin.to_f # a_variable is the variable we want to compare
      when 6,30..8,59 then periodo = "AB"
      when 9..12,59  then periodo = "CD"
      when 13..14,59  then periodo = "AB"
      when 15..17,29  then periodo = "CD"
      when 17,30..18,29 then periodo = "EF"
      when 18,30..20,59 then periodo = "AB"
      when 21..22,30 then periodo = "CD"
      end

      codigoDisciplina = turno+semanaD[dia].to_s+periodo
      puts codigoDisciplina

      getDisciplina(session[:user],codigoDisciplina)

      if @semDic == 1 then
        podeMarcar(@id_disciplina)

        getPonto(session[:user],@id_disciplina)

      end



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

  def getDisciplina(matricula,codDisc)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/getDisciplina", :form => {'matricula' => matricula, "cd_disciplina" => codDisc})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]
    puts "Retorno: ",r[0]
    @semDic = 1
    #podeMarcar(retorno["id_disciplina"])
    if retorno["vazio"] then
      @semDic = retorno["vazio"]
    else
      @id_disciplina = retorno["id_disciplina"]
      @disciplina = retorno["NOME"]
      @horario = retorno["COD_DISC"]
    end


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
