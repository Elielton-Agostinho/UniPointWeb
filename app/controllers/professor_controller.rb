class ProfessorController < ApplicationController
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
      #puts horaMin
      case horaMin.to_f # a_variable is the variable we want to compare
      when 6,30..8,59 then periodo = "AB"
      when 9..12,59  then periodo = "CD"
      when 13..14,59  then periodo = "AB"
      when 15..17,29  then periodo = "CD"
      when 17,30..18,29 then periodo = "EF"
      when 18,30..20,59 then periodo = "AB"
      when 21..22,30 then periodo = "CD"
      end

      codigoDisciplina = turno+semanaD[dia].to_s#+periodo
      # puts codigoDisciplina

      getDisciplina(session[:user],codigoDisciplina)


    end
  end

  def getUsuario(matricula)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/getProfessor", :form => {'matricula' => matricula})
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

    response = HTTP.post("https://unipointapi.herokuapp.com/getDisciplinaProf", :form => {'matricula' => matricula, "cd_disciplina" => codDisc})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)
    retorno = r[0]

    @semDic = 1

    #podeMarcar(retorno["id_disciplina"])
    if retorno["vazio"] then
      @semDic = retorno["vazio"]
    else
      obj = []

      for i in 0..((r.size) -1)
        ret = JSON.parse(response.body)
        id = ret[i]
        #puts id
        #podeMarcar(id["id_disciplina"])


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
        #puts horaMin
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
        validaPeriodo = 0
        if codigoDisciplina == id["COD_DISC"] then
          validaPeriodo = true
        else
          validaPeriodo = false
        end

        disciplinaAberta(matricula,id["ID"],codigoDisciplina)

        obj.push({"id"=>id["ID"],"nome"=>id["NOME"],"cod"=>id["COD_DISC"],"id_chmd"=>@id_chmd,"valida_periodo"=>validaPeriodo}) #,"marcacao"=>@marcacao,"ponto"=>@ponto
      end
      #puts obj
      @card = obj
      #puts @card
    end
  end

  def disciplinaAberta(matricula,disciplina,codigoDisciplina)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/verificaDisciplianAberta", :form => {'matricula' => matricula, "cd_disciplina" => disciplina,"cod_disc_comp"=>codigoDisciplina})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]

    @id_chmd = retorno["RETORNO"]

  end


end
