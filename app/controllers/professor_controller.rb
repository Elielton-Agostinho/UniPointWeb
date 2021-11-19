class ProfessorController < ApplicationController
  require 'time'
  ENV["TZ"] = "America/Fortaleza"

  require 'dotiw'
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  def index
    if session[:user].nil? == true or session[:user] == ''
      session.delete(:user)

      redirect_to '/login_prof/index'
    else
      getUsuario(session[:user])

      d = DateTime.now
      dia = d.strftime("%A")
      hora = d.strftime("%H")
      horaMin = d.strftime("%H,%M")

      @tdData = d.strftime("%d/%m/%Y")

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

      getTipoPonto(session[:user],d.strftime("%Y-%m-%d"))
      getPonto(session[:user],d.strftime("%Y-%m-%d"))
    end
  end

  def create
    tipo = params['tipoPontoPr']
    d = DateTime.now
    hora = d.strftime("%H:%M:%S")
    data = d.strftime("%Y-%m-%d")

    if tipo == 'E1' then
      puts 'Isert TB_Ponto_Professor'
      setPontoPpr(session[:user],data,hora)
    else
      setTipoPp(session[:user],data,hora,tipo)
    end
    redirect_to '/professor/index'
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
        horaMin = d.strftime("%H.%M")

        semanaD = {"Monday" => 2,"Tuesday" => 3,"Wednesday" => 4, "Thursday" => 5, "Friday" => 6, "Saturday" => 7}

        turno = ''
        case hora.to_i # a_variable is the variable we want to compare
        when 6..12 then turno = "M"
        when 13..18  then turno = "T"
        when 19..23 then turno = "N"
        end

        periodo = ''
        puts horaMin.to_f
        case horaMin.to_f # a_variable is the variable we want to compare
        when 6.30..8.59 then periodo = "AB"
        when 9..12.59  then periodo = "CD"
        when 13..14.59  then periodo = "AB"
        when 15..17.29  then periodo = "CD"
        when 17.30..18.29 then periodo = "EF"
        when 18.30..20.59 then periodo = "AB"
        when 21..22.30 then periodo = "CD"
        end
        puts periodo
        codigoDisciplina = turno+semanaD[dia].to_s+periodo
        validaPeriodo = 0
        puts codigoDisciplina,id["COD_DISC"]
        if codigoDisciplina == id["COD_DISC"] then
          validaPeriodo = true
        else
          validaPeriodo = false
        end

        id_chmd = disciplinaAberta(matricula,id["ID"],codigoDisciplina)

        obj.push({"id"=>id["ID"],"nome"=>id["NOME"],"cod"=>id["COD_DISC"],"id_chmd"=>id_chmd,"valida_periodo"=>validaPeriodo}) #,"marcacao"=>@marcacao,"ponto"=>@ponto
      end
      #puts obj
      @card = obj
      puts @card
    end
  end

  def disciplinaAberta(matricula,disciplina,codigoDisciplina)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/verificaDisciplianAberta", :form => {'matricula' => matricula, "cd_disciplina" => disciplina,"cod_disc_comp"=>codigoDisciplina})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]

    return retorno["RETORNO"]

  end

  def getTipoPonto(matricula,data)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/getTipoPontoProfessor", :form => {'matricula' => matricula, "data" => data})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]

    @tipoPontoP = retorno["RETORNO"]

    #puts @tipoPontoP
  end

  def setTipoPp(matricula,data,hora,tipo)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/setTipoPontoProfessorAux", :form => {'matricula' => matricula, "data" => data,"hora"=>hora,"tipo"=>tipo})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    @respostaMarcaPonto = response.body
    #puts @respostaMarcaPonto
  end

  def setPontoPpr(matricula,data,hora)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/setTipoPontoProfessor", :form => {'matricula' => matricula, "data" => data})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    if response.code == 200 then
      setTipoPp(matricula,data,hora,'E')
    end

    @respostaMarcaPonto = response.body
    puts @respostaMarcaPonto
  end

  def getPonto(matricula,data)
    require 'http'


    response = HTTP.post("https://unipointapi.herokuapp.com/getPontoProfessor", :form => {'matricula' => matricula, "data" => data})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)

    retorno = r[0]

    if retorno["vazio"] then
      @retPontoProf = retorno["vazio"]
      puts @retPontoProf
    else
      obj = []

      for i in 0..((r.size) -1)
        ret = JSON.parse(response.body)
        qry = ret[i]

        data = qry["DATA"].to_date

        jsonHorarios = getHorarios(qry["ID"])
        hrIni = jsonHorarios[0]
        ind = jsonHorarios.size - 1
        hrFim = jsonHorarios[ind]
        hr2 = hrFim['HORA'].to_time
        hr = hrIni['HORA'].to_time
        #puts hr,hr2
        dif = distance_of_time_in_words(hr2, hr)
        diferenca = dif.split(' and ')
        puts dif
        diferencaH = diferenca[0].split(' ')
        parte2 = diferenca[1]
        #puts parte2.nil?
        if parte2.nil? == true then
          dife = DateTime.parse('2021-11-15 00:'+diferencaH[0].to_s)
          horasTrab = dife.strftime('H.T %M')
        else
          diferencaM = diferenca[1].split(' ')
          dife = DateTime.parse(diferencaH[0].to_s+":"+diferencaM[0].to_s)
          horasTrab = dife.strftime('%H:%M')
        end


        qryData = data.strftime("%d/%m/%Y")
        @blck = diferencaH[0].to_s
        puts @blck
        obj.push({"data"=>qryData,"horarios"=>jsonHorarios,"horas_trabalhadas"=>horasTrab}) #,"marcacao"=>@marcacao,"ponto"=>@ponto
      end
      #puts obj
      @tdHorarios = obj
      #puts @tdHorarios
    end
  end

  def getHorarios(id_ponto_professor)
    require 'http'

    response = HTTP.post("https://unipointapi.herokuapp.com/getHorariosPontoProfessor", :form => {'id_ponto' => id_ponto_professor})
    response.body # retorna um objeto representando a resposta
    response.code # retorna o código HTTP da resposta, e.g. 404, 500, 200

    r = JSON.parse(response.body)
    retorno = r
    return retorno
  end

end
