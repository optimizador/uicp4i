require 'sinatra'
require 'rest-client'
#require 'webrick/https'
require 'thin'

set(:cookie_options) do
  { :expires => Time.now + 30*60 }
end


get '/' do
  logger = Logger.new(STDOUT)
  logger.info(request)
  #response['Access-Control-Allow-Origin'] = 'https://menu-dimensionamiento.9sxuen7c9q9.us-south.codeengine.appdomain.cloud/'
  erb :index

end



get '/cp4i' do
  logger = Logger.new(STDOUT)
  logger.info("Selecciono dimensionamiento para CP4I")
  @name = "CP4I"
  respuestasizing=[]
  respuestasizingalt=[]
  respuestastorage=[]
  #response['Access-Control-Allow-Origin'] = 'https://menu-dimensionamiento.9sxuen7c9q9.us-south.codeengine.appdomain.cloud/'
  erb :cp4i , :locals => {:respuestasizing => respuestasizing,:respuestasizingalt => respuestasizingalt, :respuestastorage => respuestastorage}
end



get '/cp4irespuesta' do

  logger = Logger.new(STDOUT)
  logger.info("Recibiendo parametros para dimensionamiento de CP4I: CPU: #{params[:cpu]} RAM: #{params[:ram]} Storage: #{params[:storage]} IOPS #{params[:iops]}")
  @name = "CP4I-Dimensionamiento"
  urlapi="https://apis.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"
  #urlapi="http://localhost:8080"
  cpu="#{params['cpu']}"
  ram="#{params['ram']}"
  infra_type="#{params['infra_type']}"
  region="#{params['region']}"
  storage="#{params['storage']}"
  iops="#{params['iops']}"

  #parametros recibidos
  logger.info("PRIMER LLAMADO DE API #{urlapi}/api/v2/sizingclusteroptimo?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}")
  respuestasizing = RestClient.get "#{urlapi}/api/v2/sizingclusteroptimo?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}", {:params => {}}
  respuestasizing=JSON.parse(respuestasizing.to_s)
  logger.info(respuestasizing)
  logger.info("SEGUNDO LLAMADO DE API #{urlapi}/api/v2/sizingcluster?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}")
  respuestasizingalt = RestClient.get "#{urlapi}/api/v2/sizingcluster?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}", {:params => {}}
  respuestasizingalt=JSON.parse(respuestasizingalt.to_s)
  logger.info(respuestasizingalt)
  logger.info("TERCER LLAMADO DE API #{urlapi}/api/v1/sizingblockstorage?iops=#{iops}&storage=#{storage}&region=#{region}")
  respuestastorage = RestClient.get "#{urlapi}/api/v1/sizingblockstorage?iops=#{iops}&storage=#{storage}&region=#{region}", {:params => {}}
  respuestastorage=JSON.parse(respuestastorage.to_s)
  logger.info(respuestastorage)
  logger.info("TERMINO DE LLAMAR LOS APIS")
  erb :cp4i , :locals => { :respuestasizing => respuestasizing,:respuestasizingalt => respuestasizingalt, :respuestastorage => respuestastorage}
end

  get '/cp4itemplate' do
    logger = Logger.new(STDOUT)
    logger.info("Selecciono dimensionamiento para template de CP4I")
    @name = "CP4I"
    respuestasizing=[]
    respuestasizingpx=[]
    respuestasizingalt=[]
    respuestastorage=[]
    respuestasizingga=[]
    respuestasizingdl=[]
    respuestasol=[]

    respuestamonitoring=[]
    respuestatracker=[]
    respuestaloganalysis=[]
    erb :cp4itemplate , :locals => {:respuestamonitoring => respuestamonitoring,
                                    :respuestatracker => respuestatracker,
                                    :respuestaloganalysis => respuestaloganalysis,
                                    :respuestasol => respuestasol,
                                    :respuestasizingdl => respuestasizingdl,
                                    :respuestasizingga => respuestasizingga,
                                    :respuestasizingpx => respuestasizingpx,
                                    :respuestasizing => respuestasizing,
                                    :respuestasizingalt => respuestasizingalt,
                                    :respuestastorage => respuestastorage}

  end
  get '/cp4itemplaterespuesta' do
    urlapi="https://apis.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"
    #urlapi="http://localhost:8080"
    urlapiga="https://apis-ga.9sxuen7c9q9.us-south.codeengine.appdomain.cloud/"
    #urlapiga="http://localhost:8080"
    urlapismonitoring="https://apimonitoring.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"
    #urlapismonitoring="http://localhost:3000"
    logger = Logger.new(STDOUT)
    logger.info("Selecciono dimensionamiento para template de CP4D")
    @name = "CP4I"
    ####################################
    # Parametros Generales
    ####################################
    region="#{params['region']}"
    country_offer="#{params['preciopais']}"
    tiposoporte="#{params['tiposoporte']}"

    increspaldos="#{params['increspaldos']}"
    inclogs="#{params['inclogs']}"
    inclsalud="#{params['incsalud']}"
    inclauditoria="#{params['incauditoria']}"
    inclga="#{params['incga']}"
    incldl="#{params['incdl']}"
    logger.info("Parametros generales")
    logger.info("region #{region}")
    logger.info("country_offer #{country_offer}")
    logger.info("tiposoporte #{tiposoporte}")

    logger.info("Inclusión de servicios")
    logger.info("increspaldos #{increspaldos}")
    logger.info("inclogs #{inclogs}")
    logger.info("inclsalud #{inclsalud}")
    logger.info("inclauditoria #{inclauditoria}")
    logger.info("inclga #{inclga}")
    logger.info("incldl #{incldl}")

    ####################################
    # Parametros para Clúster
    ####################################
    cpu="#{params['cpu']}"
    ram="#{params['ram']}"
    infra_type="#{params['infra_type']}"
    storage="#{params['storage']}"
    iops="#{params['iops']}"

    ####################################
    # Parametros para Respaldos
    ####################################
    logger = Logger.new(STDOUT)
    logger.info("Recibiendo parametros para dimensionamiento de PX-backup:" +
      "rsemanal:"+"#{params['rsemanal']}"+
      "rsemanalretencion:"+ "#{params['rsemanalretencion']}"+
      "rdiario: "+"#{params['rdiario']}"+
      "rdiarioretencion:"+"#{params['rdiarioretencion']}"+
      "rmensual: "+"#{params['rmensual']}"+
      "rmensualretencion:"+"#{params['rmensualretencion']}"+
      "ranual: "+"#{params['ranual']}"+
      "ranualretencion:"+"#{params['ranualretencion']}"+
      "regioncluster: "+"#{params['regioncluster']}"+
      "almacenamientogb:"+"#{params['almacenamientogb']}"+
      "countryrespaldo: "+"#{params['countryrespaldo']}"+
      "resiliencybackup:"+"#{params['resiliencybackup']}")


    almacenamientogb="#{params['almacenamientogb']}" #cantidad en GB
    #parametros de politicas
    rsemanal="#{params['rsemanal']}"
    rsemanalretencion="#{params['rsemanalretencion']}" #cantidad de backups retenidos
    rdiario="#{params['rdiario']}"
    rdiarioretencion="#{params['rdiarioretencion']}"#cantidad de backups retenidos
    rmensual="#{params['rmensual']}"
    rmensualretencion="#{params['rmensualretencion']}"#cantidad de backups retenidos
    ranual="#{params['ranual']}"
    ranualretencion="#{params['ranualretencion']}"#cantidad de backups retenidos
    regioncluster=region
    #{}"#{params['regioncluster']}"#region del cluster de IKS donde se desplegará PX-Backup
    countryrespaldo = "#{params['countryrespaldo']}"
    resiliencybackup ="#{params['resiliencybackup']}"


    ####################################
    # Parametros para Gateway Appliance
    ####################################
    logger.info("Recibiendo parametros para dimensionamiento de GatewayAppliance:")
    logger.info("Type: #{params[:typega]} Interfase: #{params[:interfase]} PII: #{params[:pii]} HA #{params[:ha]}")

    typega="#{params['typega']}"
    interfase="#{params['interfase']}"
    pii="#{params['pii']}"
    ha="#{params['ha']}"
    #parametros recibidos


    ####################################
    # Parametros para DirectLink
    ####################################
    typedl="#{params['typedl']}"
    regiondl="#{params['regiondl']}"

    puerto="#{params['puerto']}"
    routing="#{params['routing']}"
    ha="#{params['ha']}"

    nodos=0
    nodoslite=0
    respuestasizingpx=[]
    respuestasizing=[]
    respuestasizingalt=[]
    respuestastorage=[]
    respuestasizingga=[]
    respuestasizingdl=[]
    respuestasol=[]
    precioservicios=0



    ####################################
    # Cálculo de clúster óptimo
    ####################################

    logger.info("PRIMER LLAMADO DE API #{urlapi}/api/v2/sizingclusteroptimo?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}")
    respuestasizing = RestClient.get "#{urlapi}/api/v2/sizingclusteroptimo?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}", {:params => {}}
    respuestasizing=JSON.parse(respuestasizing.to_s)
    if (respuestasizing != nil and respuestasizing.size>0)


      ########################
      # Información de Cloud Monitoring
      ########################
      if infra_type=="bm"
        nodos=respuestasizing[0]["workers"].to_i
      else
        nodoslite=respuestasizing[0]["workers"].to_i
      end


      preciocluster=precioservicios+respuestasizing[0]["precio"].to_f
      precioservicios=precioservicios+preciocluster
      logger.info("Precio Clúster: #{preciocluster}")
      logger.info("Precio Servicios: #{precioservicios}")
      logger.info(respuestasizing)
    else
          logger.info("NO SE OBTUVO SIZING DEL CLUSTER")
    end

    ####################################
    # Alternativas de clúster al óptimo
    ####################################
    logger.info("SEGUNDO LLAMADO DE API #{urlapi}/api/v2/sizingcluster?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}")
    respuestasizingalt = RestClient.get "#{urlapi}/api/v2/sizingcluster?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}", {:params => {}}
    respuestasizingalt=JSON.parse(respuestasizingalt.to_s)
    logger.info(respuestasizingalt)

    ####################################
    # Cálculo de storage
    ####################################

    logger.info("API Storage #{urlapi}/api/v1/sizingblockstorage?iops=#{iops}&storage=#{storage}&region=#{region}")
    respuestastorage = RestClient.get "#{urlapi}/api/v1/sizingblockstorage?iops=#{iops}&storage=#{storage}&region=#{region}", {:params => {}}
    respuestastorage=JSON.parse(respuestastorage.to_s)
    logger.info(respuestastorage)
    if (respuestastorage != nil and respuestastorage.size>0)
      preciostorage=respuestastorage[0]["precio"].to_f+respuestastorage[0]["preciounidadrestante"].to_f
      precioservicios=precioservicios+preciostorage
      logger.info("Precio Storage: #{preciostorage}")
      logger.info("Precio Servicios: #{precioservicios}")
    else
          logger.info("NO SE OBTUVO SIZING DE STORAGE")
    end

    ####################################
    #Cálculo de logs
    ####################################
    if inclogs=="true"
        logger.info("=====>>>  INCLUYE LOGS")
        storagelogs="#{params['storagelogs']}"
        loganalysis_retencion="#{params['loganalysis_retencion']}"
        logger.info("API LOG ANALYSIS #{urlapismonitoring}/LogAnalysis?GB=#{storagelogs}&dias=#{loganalysis_retencion}&region=us-south&preciopais=mexico")
        respuestaloganalysis=[]
        respuestaloganalysis = RestClient.post "#{urlapismonitoring}/LogAnalysis?GB=#{storagelogs}&dias=#{loganalysis_retencion}&region=us-south&preciopais=mexico", {:params => {}}
        respuestaloganalysis =JSON.parse(respuestaloganalysis.to_s)
        logger.info(respuestaloganalysis)
        if (respuestaloganalysis != nil and respuestaloganalysis.size>0)
          preciolog=respuestaloganalysis["total"].to_f
          precioservicios=precioservicios+preciolog
          logger.info("Precio LogAnalysis: #{preciolog}")
          logger.info("Precio Servicios: #{precioservicios}")
        else
              logger.info("NO SE OBTUVO SIZING DE LOG ANALYSIS")
        end

    else
        logger.info("=====>>> NO INCLUYE LOGS")
    end


    ####################################
    #Cálculo de auditoria
    ####################################
    if inclauditoria=="true"
        logger.info("=====>>>  INCLUYE AUDITORIA")
        storagetracker="#{params['storagetracker']}"
        tracker_retencion="#{params['tracker_retencion']}"
        logger.info("API ACTIVITY TRACKER #{urlapismonitoring}/ActivityTracker?GB=#{storagetracker}&dias=#{tracker_retencion}&region=us-south&preciopais=mexico")
        respuestatracker=[]
        respuestatracker = RestClient.post "#{urlapismonitoring}/ActivityTracker?GB=#{storagetracker}&dias=#{tracker_retencion}&region=us-south&preciopais=mexico", {:params => {}}
        respuestatracker =JSON.parse(respuestatracker.to_s)
        logger.info(respuestatracker)
        if (respuestatracker != nil and respuestatracker.size>0)
          preciotracker=respuestatracker["total"].to_f
          precioservicios=precioservicios+preciotracker
          logger.info("Precio Activity Tracker: #{preciotracker}")
          logger.info("Precio Servicios: #{precioservicios}")
        else
              logger.info("NO SE OBTUVO SIZING DE ACTIVITY TRACKER")
        end

    else
        logger.info("=====>>> NO INCLUYE AUDITORIA")
    end

    ####################################
    #Cálculo de auditoria
    ####################################
    if inclsalud=="true"
        logger.info("=====>>>  INCLUYE MONITOREO SALUD")
        #nodoslite
        #nodos
        #contenedores
        #seriestiempo
        contenedores="#{params['contenedores']}"
        seriestiempo="#{params['seriestiempo']}"
        logger.info("API MONITORING #{urlapismonitoring}/CloudMonitoring?node=#{nodos}&litenode=#{nodoslite}&region=us-south&preciopais=mexico&container=#{contenedores}&timeserieshour=#{seriestiempo}")
        respuestamonitoring=[]
        respuestamonitoring = RestClient.post "#{urlapismonitoring}/CloudMonitoring?node=#{nodos}&litenode=#{nodoslite}&region=us-south&preciopais=mexico&container=#{contenedores}&timeserieshour=#{seriestiempo}", {:params => {}}
        respuestamonitoring =JSON.parse(respuestamonitoring.to_s)
        logger.info(respuestamonitoring)
        if (respuestamonitoring != nil and respuestamonitoring.size>0)
          preciomonitoring=respuestamonitoring["total"].to_f
          precioservicios=precioservicios+preciomonitoring
          logger.info("Precio Cloud Monitoring: #{preciomonitoring}")
          logger.info("Precio Servicios: #{precioservicios}")
        else
              logger.info("NO SE OBTUVO SIZING DE MONITORING")
        end

    else
        logger.info("=====>>> NO INCLUYE MONITOREO SALUD")
    end

    ####################################
    #Cálculo de respaldos
    ####################################
    if increspaldos=="true"
        logger.info("llamado api PX-Backup:" )
        logger.info("#{urlapi}/api/lvl2/pxbackupsol?almacenamientogb=#{almacenamientogb}&rsemanal=#{rsemanal}&rsemanalretencion=#{rsemanalretencion}&rdiario=#{rdiario}&rdiarioretencion=#{rdiarioretencion}&rmensual=#{rmensual}&rmensualretencion=#{rmensualretencion}&ranual=#{ranual}&ranualretencion=#{ranualretencion}&regioncluster=#{regioncluster}&countryrespaldo=#{countryrespaldo}&resiliencybackup=#{resiliencybackup}")
        respuestasizingpx = RestClient.get "#{urlapi}/api/lvl2/pxbackupsol?almacenamientogb=#{almacenamientogb}&rsemanal=#{rsemanal}&rsemanalretencion=#{rsemanalretencion}&rdiario=#{rdiario}&rdiarioretencion=#{rdiarioretencion}&rmensual=#{rmensual}&rmensualretencion=#{rmensualretencion}&ranual=#{ranual}&ranualretencion=#{ranualretencion}&regioncluster=#{regioncluster}&countryrespaldo=#{countryrespaldo}&resiliencybackup=#{resiliencybackup}", {:params => {}}
        respuestasizingpx = JSON.parse(respuestasizingpx.to_s)
        logger.info("*************")
        logger.info(respuestasizingpx)
        precioiks=respuestasizingpx[1]["precio"]
        preciocos=respuestasizingpx[3]["precio"]
        preciopx=respuestasizingpx[2]["precio"]
        precioservicios=precioservicios+preciopx+preciocos+precioiks
        logger.info("Precio Sol PX: IKS #{precioiks} COS #{preciocos} PX #{preciopx}")
        logger.info("Precio Servicios: #{precioservicios}")
    else
        logger.info("=====>>> NO INCLUYE RESPALDOS")
    end


    ####################################
    #Cálculo de gateway appliance
    ####################################
    if inclga=="true"
        logger.info("llamado api GA:" )
        logger.info("#{urlapiga}/api/v1/sizingga?region=#{region}&type=#{typega}&interfase=#{interfase}&ha=#{ha}&pii=#{pii}")
        respuestasizingga = RestClient.get "#{urlapiga}/api/v1/sizingga?region=#{region}&type=#{typega}&interfase=#{interfase}&ha=#{ha}&pii=#{pii}", {:params => {}}
        respuestasizingga=JSON.parse(respuestasizingga.to_s)
        logger.info("*************")
        logger.info(respuestasizingga)
        precioga=respuestasizingga[0]["precio"].to_f
        precioservicios=precioservicios+precioga
        logger.info("Precio Gateway Appliance: #{precioga}")
        logger.info("Precio Servicios: #{precioservicios}")
    else
        logger.info("=====>>> NO INCLUYE GATEWAY APPLIANCE")
    end

    ####################################
    #Cálculo de Direct Link
    ####################################
    if incldl=="true"
        logger.info("llamado api DL:" )
        respuestasizingdl = RestClient.get "#{urlapiga}/api/v1/sizingdl?region=#{regiondl}&type=#{typedl}&country_offer=#{country_offer}&puerto=#{puerto}&routing=#{routing}&ha=#{ha}", {:params => {}}
        respuestasizingdl=JSON.parse(respuestasizingdl.to_s)
        logger.info("*************")
        logger.info(respuestasizingdl)
        preciodl=respuestasizingdl[0]["precio"].to_f
        precioservicios=precioservicios+preciodl
        logger.info("Precio Direct Link: #{preciodl}")
        logger.info("Precio Servicios: #{precioservicios}")
    else
          logger.info("=====>>> NO INCLUYE DIRECT LINK")
    end

    respuestasoporte=[]
    llamadoapisoporte="#{urlapi}/api/v1/sizingsupport?type=#{tiposoporte}&precioservicios=#{precioservicios}"
    logger.info("Llamado API Soporte #{llamadoapisoporte}")
    respuestasoporte = RestClient.get llamadoapisoporte, {:params => {}}
    logger.info("Respuesta API Soporte #{respuestasoporte}")
    respuestasoporte=JSON.parse(respuestasoporte.to_s)
    preciosoporte=respuestasoporte["precio"].to_f
    preciototal=preciosoporte+precioservicios
    respuestasol=[]
    respuestasol.push({total:preciototal.round(2).to_s,soporte:preciosoporte.round(2).to_s,servicios:precioservicios.round(2).to_s})
    #respuestasol=respuestasol.to_json
    logger.info("Precio Servicios: #{precioservicios}")
    logger.info("Precio Soporte: #{preciosoporte}")
    logger.info("Precio Total: #{preciototal}")

    logger.info("TERMINO DE LLAMAR LOS APIS")

    #response['Access-Control-Allow-Origin'] = 'https://menu-dimensionamiento.9sxuen7c9q9.us-south.codeengine.appdomain.cloud/'
    erb :cp4itemplate , :locals => {:respuestamonitoring => respuestamonitoring,
                                    :respuestatracker => respuestatracker,
                                    :respuestaloganalysis => respuestaloganalysis,
                                    :respuestasol => respuestasol,
                                    :respuestasizingdl => respuestasizingdl,
                                    :respuestasizingga => respuestasizingga,
                                    :respuestasizingpx => respuestasizingpx,
                                    :respuestasizing => respuestasizing,
                                    :respuestasizingalt => respuestasizingalt,
                                    :respuestastorage => respuestastorage}
  end


#########################################
# Template producción
#########################################

get '/cp4itemplateproduccion' do
  logger = Logger.new(STDOUT)
  logger.info("Selecciono dimensionamiento para template de CP4I")
  @name = "CP4I"
  respuestasizing=[]
  respuestasizingpx=[]
  respuestasizingalt=[]
  respuestastorage=[]
  respuestasizingga=[]
  respuestasizingdl=[]
  respuestasol=[]

  respuestamonitoring=[]
  respuestatracker=[]
  respuestaloganalysis=[]
  erb :cp4itemplateproduccion , :locals => {:respuestamonitoring => respuestamonitoring,
                                  :respuestatracker => respuestatracker,
                                  :respuestaloganalysis => respuestaloganalysis,
                                  :respuestasol => respuestasol,
                                  :respuestasizingdl => respuestasizingdl,
                                  :respuestasizingga => respuestasizingga,
                                  :respuestasizingpx => respuestasizingpx,
                                  :respuestasizing => respuestasizing,
                                  :respuestasizingalt => respuestasizingalt,
                                  :respuestastorage => respuestastorage}

end
get '/cp4itemplateproduccionrespuesta' do
  urlapi="https://apis.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"
  #urlapi="http://localhost:8080"
  urlapiga="https://apis-ga.9sxuen7c9q9.us-south.codeengine.appdomain.cloud/"
  #urlapiga="http://localhost:8080"
  urlapismonitoring="https://apimonitoring.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"
  #urlapismonitoring="http://localhost:3000"
  logger = Logger.new(STDOUT)
  logger.info("Selecciono dimensionamiento para template de CP4D")
  @name = "CP4D"
  ####################################
  # Parametros Generales
  ####################################
  region="#{params['region']}"
  country_offer="#{params['preciopais']}"
  tiposoporte="#{params['tiposoporte']}"

  increspaldos="#{params['increspaldos']}"
  inclogs="#{params['inclogs']}"
  inclsalud="#{params['incsalud']}"
  inclauditoria="#{params['incauditoria']}"
  inclga="#{params['incga']}"
  incldl="#{params['incdl']}"
  logger.info("Parametros generales")
  logger.info("region #{region}")
  logger.info("country_offer #{country_offer}")
  logger.info("tiposoporte #{tiposoporte}")

  logger.info("Inclusión de servicios")
  logger.info("increspaldos #{increspaldos}")
  logger.info("inclogs #{inclogs}")
  logger.info("inclsalud #{inclsalud}")
  logger.info("inclauditoria #{inclauditoria}")
  logger.info("inclga #{inclga}")
  logger.info("incldl #{incldl}")

  ####################################
  # Parametros para Clúster
  ####################################
  cpu="#{params['cpu']}"
  ram="#{params['ram']}"
  infra_type="#{params['infra_type']}"
  storage="#{params['storage']}"
  iops="#{params['iops']}"

  ####################################
  # Parametros para Respaldos
  ####################################
  logger = Logger.new(STDOUT)
  logger.info("Recibiendo parametros para dimensionamiento de PX-backup:" +
    "rsemanal:"+"#{params['rsemanal']}"+
    "rsemanalretencion:"+ "#{params['rsemanalretencion']}"+
    "rdiario: "+"#{params['rdiario']}"+
    "rdiarioretencion:"+"#{params['rdiarioretencion']}"+
    "rmensual: "+"#{params['rmensual']}"+
    "rmensualretencion:"+"#{params['rmensualretencion']}"+
    "ranual: "+"#{params['ranual']}"+
    "ranualretencion:"+"#{params['ranualretencion']}"+
    "regioncluster: "+"#{params['regioncluster']}"+
    "almacenamientogb:"+"#{params['almacenamientogb']}"+
    "countryrespaldo: "+"#{params['countryrespaldo']}"+
    "resiliencybackup:"+"#{params['resiliencybackup']}")


  almacenamientogb="#{params['almacenamientogb']}" #cantidad en GB
  #parametros de politicas
  rsemanal="#{params['rsemanal']}"
  rsemanalretencion="#{params['rsemanalretencion']}" #cantidad de backups retenidos
  rdiario="#{params['rdiario']}"
  rdiarioretencion="#{params['rdiarioretencion']}"#cantidad de backups retenidos
  rmensual="#{params['rmensual']}"
  rmensualretencion="#{params['rmensualretencion']}"#cantidad de backups retenidos
  ranual="#{params['ranual']}"
  ranualretencion="#{params['ranualretencion']}"#cantidad de backups retenidos
  regioncluster=region
  #{}"#{params['regioncluster']}"#region del cluster de IKS donde se desplegará PX-Backup
  countryrespaldo = "#{params['countryrespaldo']}"
  resiliencybackup ="#{params['resiliencybackup']}"


  ####################################
  # Parametros para Gateway Appliance
  ####################################
  logger.info("Recibiendo parametros para dimensionamiento de GatewayAppliance:")
  logger.info("Type: #{params[:typega]} Interfase: #{params[:interfase]} PII: #{params[:pii]} HA #{params[:ha]}")

  typega="#{params['typega']}"
  interfase="#{params['interfase']}"
  pii="#{params['pii']}"
  ha="#{params['ha']}"
  #parametros recibidos


  ####################################
  # Parametros para DirectLink
  ####################################
  typedl="#{params['typedl']}"
  regiondl="#{params['regiondl']}"

  puerto="#{params['puerto']}"
  routing="#{params['routing']}"
  ha="#{params['ha']}"

  nodos=0
  nodoslite=0
  respuestasizingpx=[]
  respuestasizing=[]
  respuestasizingalt=[]
  respuestastorage=[]
  respuestasizingga=[]
  respuestasizingdl=[]
  respuestasol=[]
  precioservicios=0



  ####################################
  # Cálculo de clúster óptimo
  ####################################

  logger.info("PRIMER LLAMADO DE API #{urlapi}/api/v2/sizingclusteroptimoproductivo?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}")
  respuestasizing = RestClient.get "#{urlapi}/api/v2/sizingclusteroptimoproductivo?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}", {:params => {}}
  respuestasizing=JSON.parse(respuestasizing.to_s)
  if (respuestasizing != nil and respuestasizing.size>0)


    ########################
    # Información de Cloud Monitoring
    ########################
    if infra_type=="bm"
      nodos=respuestasizing[0]["workers"].to_i
    else
      nodoslite=respuestasizing[0]["workers"].to_i
    end


    preciocluster=precioservicios+respuestasizing[0]["precio"].to_f
    precioservicios=precioservicios+preciocluster
    logger.info("Precio Clúster: #{preciocluster}")
    logger.info("Precio Servicios: #{precioservicios}")
    logger.info(respuestasizing)
  else
        logger.info("NO SE OBTUVO SIZING DEL CLUSTER")
  end

  ####################################
  # Alternativas de clúster al óptimo
  ####################################
  logger.info("SEGUNDO LLAMADO DE API #{urlapi}/api/v2/sizingclusterproductivo?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}")
  respuestasizingalt = RestClient.get "#{urlapi}/api/v2/sizingclusterproductivo?cpu=#{cpu}&ram=#{ram}&infra_type=#{infra_type}&region=#{region}", {:params => {}}
  respuestasizingalt=JSON.parse(respuestasizingalt.to_s)
  logger.info(respuestasizingalt)

  ####################################
  # Cálculo de storage
  ####################################

  logger.info("API Storage #{urlapi}/api/v1/sizingblockstorage?iops=#{iops}&storage=#{storage}&region=#{region}")
  respuestastorage = RestClient.get "#{urlapi}/api/v1/sizingblockstorage?iops=#{iops}&storage=#{storage}&region=#{region}", {:params => {}}
  respuestastorage=JSON.parse(respuestastorage.to_s)
  logger.info(respuestastorage)
  if (respuestastorage != nil and respuestastorage.size>0)
    preciostorage=respuestastorage[0]["precio"].to_f+respuestastorage[0]["preciounidadrestante"].to_f
    precioservicios=precioservicios+preciostorage
    logger.info("Precio Storage: #{preciostorage}")
    logger.info("Precio Servicios: #{precioservicios}")
  else
        logger.info("NO SE OBTUVO SIZING DE STORAGE")
  end

  ####################################
  #Cálculo de logs
  ####################################
  if inclogs=="true"
      logger.info("=====>>>  INCLUYE LOGS")
      storagelogs="#{params['storagelogs']}"
      loganalysis_retencion="#{params['loganalysis_retencion']}"
      logger.info("API LOG ANALYSIS #{urlapismonitoring}/LogAnalysis?GB=#{storagelogs}&dias=#{loganalysis_retencion}&region=us-south&preciopais=mexico")
      respuestaloganalysis=[]
      respuestaloganalysis = RestClient.post "#{urlapismonitoring}/LogAnalysis?GB=#{storagelogs}&dias=#{loganalysis_retencion}&region=us-south&preciopais=mexico", {:params => {}}
      respuestaloganalysis =JSON.parse(respuestaloganalysis.to_s)
      logger.info(respuestaloganalysis)
      if (respuestaloganalysis != nil and respuestaloganalysis.size>0)
        preciolog=respuestaloganalysis["total"].to_f
        precioservicios=precioservicios+preciolog
        logger.info("Precio LogAnalysis: #{preciolog}")
        logger.info("Precio Servicios: #{precioservicios}")
      else
            logger.info("NO SE OBTUVO SIZING DE LOG ANALYSIS")
      end

  else
      logger.info("=====>>> NO INCLUYE LOGS")
  end


  ####################################
  #Cálculo de auditoria
  ####################################
  if inclauditoria=="true"
      logger.info("=====>>>  INCLUYE AUDITORIA")
      storagetracker="#{params['storagetracker']}"
      tracker_retencion="#{params['tracker_retencion']}"
      logger.info("API ACTIVITY TRACKER #{urlapismonitoring}/ActivityTracker?GB=#{storagetracker}&dias=#{tracker_retencion}&region=us-south&preciopais=mexico")
      respuestatracker=[]
      respuestatracker = RestClient.post "#{urlapismonitoring}/ActivityTracker?GB=#{storagetracker}&dias=#{tracker_retencion}&region=us-south&preciopais=mexico", {:params => {}}
      respuestatracker =JSON.parse(respuestatracker.to_s)
      logger.info(respuestatracker)
      if (respuestatracker != nil and respuestatracker.size>0)
        preciotracker=respuestatracker["total"].to_f
        precioservicios=precioservicios+preciotracker
        logger.info("Precio Activity Tracker: #{preciotracker}")
        logger.info("Precio Servicios: #{precioservicios}")
      else
            logger.info("NO SE OBTUVO SIZING DE ACTIVITY TRACKER")
      end

  else
      logger.info("=====>>> NO INCLUYE AUDITORIA")
  end

  ####################################
  #Cálculo de auditoria
  ####################################
  if inclsalud=="true"
      logger.info("=====>>>  INCLUYE MONITOREO SALUD")
      #nodoslite
      #nodos
      #contenedores
      #seriestiempo
      contenedores="#{params['contenedores']}"
      seriestiempo="#{params['seriestiempo']}"
      logger.info("API MONITORING #{urlapismonitoring}/CloudMonitoring?node=#{nodos}&litenode=#{nodoslite}&region=us-south&preciopais=mexico&container=#{contenedores}&timeserieshour=#{seriestiempo}")
      respuestamonitoring=[]
      respuestamonitoring = RestClient.post "#{urlapismonitoring}/CloudMonitoring?node=#{nodos}&litenode=#{nodoslite}&region=us-south&preciopais=mexico&container=#{contenedores}&timeserieshour=#{seriestiempo}", {:params => {}}
      respuestamonitoring =JSON.parse(respuestamonitoring.to_s)
      logger.info(respuestamonitoring)
      if (respuestamonitoring != nil and respuestamonitoring.size>0)
        preciomonitoring=respuestamonitoring["total"].to_f
        precioservicios=precioservicios+preciomonitoring
        logger.info("Precio Cloud Monitoring: #{preciomonitoring}")
        logger.info("Precio Servicios: #{precioservicios}")
      else
            logger.info("NO SE OBTUVO SIZING DE MONITORING")
      end

  else
      logger.info("=====>>> NO INCLUYE MONITOREO SALUD")
  end

  ####################################
  #Cálculo de respaldos
  ####################################
  if increspaldos=="true"
      logger.info("llamado api PX-Backup:" )
      logger.info("#{urlapi}/api/lvl2/pxbackupsol?almacenamientogb=#{almacenamientogb}&rsemanal=#{rsemanal}&rsemanalretencion=#{rsemanalretencion}&rdiario=#{rdiario}&rdiarioretencion=#{rdiarioretencion}&rmensual=#{rmensual}&rmensualretencion=#{rmensualretencion}&ranual=#{ranual}&ranualretencion=#{ranualretencion}&regioncluster=#{regioncluster}&countryrespaldo=#{countryrespaldo}&resiliencybackup=#{resiliencybackup}")
      respuestasizingpx = RestClient.get "#{urlapi}/api/lvl2/pxbackupsol?almacenamientogb=#{almacenamientogb}&rsemanal=#{rsemanal}&rsemanalretencion=#{rsemanalretencion}&rdiario=#{rdiario}&rdiarioretencion=#{rdiarioretencion}&rmensual=#{rmensual}&rmensualretencion=#{rmensualretencion}&ranual=#{ranual}&ranualretencion=#{ranualretencion}&regioncluster=#{regioncluster}&countryrespaldo=#{countryrespaldo}&resiliencybackup=#{resiliencybackup}", {:params => {}}
      respuestasizingpx = JSON.parse(respuestasizingpx.to_s)
      logger.info("*************")
      logger.info(respuestasizingpx)
      precioiks=respuestasizingpx[1]["precio"]
      preciocos=respuestasizingpx[3]["precio"]
      preciopx=respuestasizingpx[2]["precio"]
      precioservicios=precioservicios+preciopx+preciocos+precioiks
      logger.info("Precio Sol PX: IKS #{precioiks} COS #{preciocos} PX #{preciopx}")
      logger.info("Precio Servicios: #{precioservicios}")
  else
      logger.info("=====>>> NO INCLUYE RESPALDOS")
  end


  ####################################
  #Cálculo de gateway appliance
  ####################################
  if inclga=="true"
      logger.info("llamado api GA:" )
      logger.info("#{urlapiga}/api/v1/sizingga?region=#{region}&type=#{typega}&interfase=#{interfase}&ha=#{ha}&pii=#{pii}")
      respuestasizingga = RestClient.get "#{urlapiga}/api/v1/sizingga?region=#{region}&type=#{typega}&interfase=#{interfase}&ha=#{ha}&pii=#{pii}", {:params => {}}
      respuestasizingga=JSON.parse(respuestasizingga.to_s)
      logger.info("*************")
      logger.info(respuestasizingga)
      precioga=respuestasizingga[0]["precio"].to_f
      precioservicios=precioservicios+precioga
      logger.info("Precio Gateway Appliance: #{precioga}")
      logger.info("Precio Servicios: #{precioservicios}")
  else
      logger.info("=====>>> NO INCLUYE GATEWAY APPLIANCE")
  end

  ####################################
  #Cálculo de Direct Link
  ####################################
  if incldl=="true"
      logger.info("llamado api DL:" )
      respuestasizingdl = RestClient.get "#{urlapiga}/api/v1/sizingdl?region=#{regiondl}&type=#{typedl}&country_offer=#{country_offer}&puerto=#{puerto}&routing=#{routing}&ha=#{ha}", {:params => {}}
      respuestasizingdl=JSON.parse(respuestasizingdl.to_s)
      logger.info("*************")
      logger.info(respuestasizingdl)
      preciodl=respuestasizingdl[0]["precio"].to_f
      precioservicios=precioservicios+preciodl
      logger.info("Precio Direct Link: #{preciodl}")
      logger.info("Precio Servicios: #{precioservicios}")
  else
        logger.info("=====>>> NO INCLUYE DIRECT LINK")
  end

  respuestasoporte=[]
  llamadoapisoporte="#{urlapi}/api/v1/sizingsupport?type=#{tiposoporte}&precioservicios=#{precioservicios}"
  logger.info("Llamado API Soporte #{llamadoapisoporte}")
  respuestasoporte = RestClient.get llamadoapisoporte, {:params => {}}
  logger.info("Respuesta API Soporte #{respuestasoporte}")
  respuestasoporte=JSON.parse(respuestasoporte.to_s)
  preciosoporte=respuestasoporte["precio"].to_f
  preciototal=preciosoporte+precioservicios
  respuestasol=[]
  respuestasol.push({total:preciototal.round(2).to_s,soporte:preciosoporte.round(2).to_s,servicios:precioservicios.round(2).to_s})
  #respuestasol=respuestasol.to_json
  logger.info("Precio Servicios: #{precioservicios}")
  logger.info("Precio Soporte: #{preciosoporte}")
  logger.info("Precio Total: #{preciototal}")

  logger.info("TERMINO DE LLAMAR LOS APIS")

  #response['Access-Control-Allow-Origin'] = 'https://menu-dimensionamiento.9sxuen7c9q9.us-south.codeengine.appdomain.cloud/'
  erb :cp4itemplateproduccion , :locals => {:respuestamonitoring => respuestamonitoring,
                                  :respuestatracker => respuestatracker,
                                  :respuestaloganalysis => respuestaloganalysis,
                                  :respuestasol => respuestasol,
                                  :respuestasizingdl => respuestasizingdl,
                                  :respuestasizingga => respuestasizingga,
                                  :respuestasizingpx => respuestasizingpx,
                                  :respuestasizing => respuestasizing,
                                  :respuestasizingalt => respuestasizingalt,
                                  :respuestastorage => respuestastorage}
end
