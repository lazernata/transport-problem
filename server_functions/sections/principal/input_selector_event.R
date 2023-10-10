i18n <- Translator$new(translation_json_path = "data/translation.json")
i18n$set_translation_language("es") # here you select the default translation to display

observeEvent(input$selected_language, {
  # This print is just for demonstration
  print(paste("Language change!", input$selected_language))
  # Here is where we update language in session
  shiny.i18n::update_lang(input$selected_language)
})

output$problem_select <- renderUI({
  pickerInput(inputId = "tipo", #Tipo de problema
              label = h4(i18n$t("Seleccione el tipo de problema")),
              choices = setNames(c(1,2,3), c(i18n$t("El problema de transporte"), 
                                             i18n$t("El problema con transbordo"),
                                             i18n$t("El problema de asignación"))),
              options = list(
                style = "btn-success"))
})

output$selector_direction <- renderUI({
  prettyRadioButtons(inputId = "dir", 
                     label = h4(i18n$t("¿Cuál es el objetivo del problema?")),
                     choices = setNames(c(1,2), c(i18n$t("Maximizar"),
                                                  i18n$t("Minimizar"))),
                     icon = icon("check-circle"),
                     bigger = TRUE,
                     status = "success",
                     animation = "jelly",
                     selected = 2)
})

ir <- reactive(input$rows)
ic <- reactive(input$columns)

#La matriz de costos
output$changing_mat <- renderUI({
  
  validate(
    need(isTruthy(ir()),label = "rows"),
    need(isTruthy(ic()),label = "columns"))
  
  matrixInput("matrix1",
              label = NULL,
              value = matrix(data=0,
                             nrow=ir(),
                             ncol=ic(),
                             dimnames = list(paste0(i18n$t("Origen: "),letters[1:ir()]),
                                             paste0(i18n$t("Destino: "),letters[1:ic()]))),
              rows = list(
                n=ir(),
                names = TRUE),
              
              cols = list (
                n=ic(),
                names = TRUE),
              class = "numeric")})

#La matriz de ofertas
output$ofertas <- renderUI(
  matrixInput("matrixO",
              label = NULL,
              value = matrix(data=0,
                             nrow=ir(),
                             ncol=1,
                             dimnames = list(NULL,i18n$t("Ofertas"))),
              rows = list(
                n=ir(),
                names = FALSE,
                editableNames = FALSE),
              
              cols = list (
                n=1,
                names = TRUE,
                editableNames = FALSE),
              class = "numeric"))

#La matriz de demandas
output$demandas <- renderUI(
  matrixInput("matrixD",
              value = matrix(data=0,
                             nrow=1,
                             ncol=ic(),
                             dimnames = list(i18n$t("Demandas"))),
              rows = list(
                n=1,
                names = TRUE,
                editableNames = FALSE),
              
              cols = list (
                n=ic(),
                names = FALSE,
                editableNames = FALSE),
              class = "numeric"))

#Las direcciones para las ofertas
output$signos_of <- renderUI(
  matrixInput("matrixSO",
              label = NULL,
              value = matrix(nrow=ir(),
                             ncol=1,
                             dimnames = list(NULL,i18n$t("Signos"))),
              rows = list(
                n=ir(),
                names = FALSE,
                editableNames = FALSE),
              
              cols = list(
                n=1,
                names = TRUE,
                editableNames = FALSE),
              class = "character"))

#Las direcciones para las demandas
output$signos_dem <- renderUI(
  matrixInput("matrixSD",
              value = matrix(nrow=1,
                             ncol=ic(),
                             dimnames = list(i18n$t("Signos"))),
              rows = list(
                n=1,
                names = TRUE,
                editableNames = FALSE),
              
              cols = list (
                n=ic(),
                names = FALSE,
                editableNames = FALSE),
              class = "character"))

#En el caso del problema de asignación, dejamos sólo la matriz de costos, ya que las demás no son necesarias
observeEvent(input$tipo, {
  
  if(input$tipo == 1 || input$tipo == 2){
    show("ocultar")
    show("ocultar1")
  } else{
    hide("ocultar")
    hide("ocultar1")
  }
  
})

#Se añade el validator para las matrices de signos, para que no se pare la aplicación si el vector está vació o tiene los valores inadecuados
iv <- InputValidator$new()
iv$add_rule("matrixSO",  sv_in_set(c("<",">", "<=", ">="), message_fmt = "Must be {values_text}."))
iv$add_rule("matrixSD",  sv_in_set(c("<",">", "<=", ">="), message_fmt = "Must be {values_text}."))
iv$enable()

#Se definen los argumentos de la función lp.transport como reactivos
f.cost <- reactive(as.matrix(input$matrix1)) #la matriz de costos
f.row.dir <- reactive(as.vector(input$matrixSO)) #el vector con los signos de las filas
f.row.rhs <- reactive(as.vector(input$matrixO)) #el vector con los valores de las ofertas
f.col.dir <- reactive(as.vector(input$matrixSD)) #el vector con los signos de las columnas
f.col.rhs <- reactive(as.vector(input$matrixD)) #el vector con los valores de las demandas
f.row.rhs_1 <- reactive(f.row.rhs() + sum(f.row.rhs())) #el vector con los valores de las ofertas para el problema de transbordo
f.col.rhs_1 <- reactive(f.col.rhs() + sum(f.col.rhs())) #el vector con los valores de las demandas para el problema de transbordo

#Se devuelve la solución al usuarios tras pulsar el botón de solución
observeEvent(input$sol, {
  
  if(input$dir == 2 && input$tipo == 1){ #Problema de transporte + minimizar
    
    req(iv$is_valid())
    
    #Se calcula la solución con los datos introducidos
    transporte <- lp.transport(cost.mat=f.cost(), direction = "min", row.signs=f.row.dir(), row.rhs=f.row.rhs(), col.signs=f.col.dir(), col.rhs=f.col.rhs(), integers=NULL)
    
    #La matriz de solución se convierte en un data frame 
    solution <- as.data.frame(transporte$solution)
    rownames(solution) <- paste0(i18n$t("Origen: "), letters[1:nrow(solution)])
    colnames(solution) <- paste0(i18n$t("Destino: "),letters[1:ncol(solution)])
    
    #Se guarda el valor objetivo del problema
    ValObj <- transporte$objval
    
    if(ValObj == 0){ #Se muestra la notificación en el caso que el problema no esté balanceado
      showNotification(i18n$t("El problema no está balanceado"),
                       duration = 10, 
                       closeButton = TRUE,
                       type = "error")
    }
    
    output$solucion <- renderDataTable( #Se renderiza la tabla de solución
      datatable(solution,
                filter = "none",
                options = list(
                  dom = "t",
                  searching = F
                ),
                rownames = T))
    
    #El valor objetivo se devuelve al usuario como un ValueBox
    output$ValorObj <- renderValueBox(
      valueBox(subtitle = i18n$t("El Valor Objetivo "),
        ValObj,
        color = "green",
        icon = icon("check")))
    
  }else if(input$dir == 1 && input$tipo == 1){ #Problema de transporte + maximizar
    
    req(iv$is_valid())
    
    transporte <- lp.transport(cost.mat=f.cost(), direction = "max", row.signs=f.row.dir(), row.rhs=f.row.rhs(), col.signs=f.col.dir(), col.rhs=f.col.rhs(), integers=NULL)
    solution <- as.data.frame(transporte$solution)
    rownames(solution) <- paste0(i18n$t("Origen: "), letters[1:nrow(solution)])
    colnames(solution) <- paste0(i18n$t("Destino: "),letters[1:ncol(solution)])

    ValObj <- transporte$objval
    
    if(ValObj == 0){ #Se muestra la notificación en el caso que el problema no esté balanceado
      showNotification(i18n$t("El problema no está balanceado"),
                       duration = 10, 
                       closeButton = TRUE,
                       type = "error")
    }
    
    output$solucion <- renderDataTable(
      datatable(solution,
                filter = "none",
                options = list(
                  dom = "t",
                  searching = F
                ),
                rownames = T))

    output$ValorObj <- renderValueBox(
      valueBox(
        subtitle = i18n$t("El Valor Objetivo "),
        ValObj,
        color = "green",
        icon = icon("check")))

  }else if(input$dir == 2 && input$tipo == 2){ #Problema con transbordo + minimizar
    
    req(iv$is_valid())
    
    transporte <- lp.transport(cost.mat=f.cost(), direction = "min", row.signs=f.row.dir(), row.rhs=f.row.rhs_1(), col.signs=f.col.dir(), col.rhs=f.col.rhs_1(), integers=NULL)
    solution <- as.data.frame(transporte$solution)
    rownames(solution) <- paste0(i18n$t("Origen: "), letters[1:nrow(solution)])
    colnames(solution) <- paste0(i18n$t("Destino: "),letters[1:ncol(solution)])

    #En el caso del problema con transbordo, hace falta ignorar los valores en la  diagonal.
    #Por lo cual, para mayor comodidad, se convierten en ceros
    ValObj <- transporte$objval
    diag(solution) <- 0
    
    if(ValObj == 0){ #Se muestra la notificación en el caso que el problema no esté balanceado
      showNotification(i18n$t("El problema no está balanceado"),
                       duration = 10, 
                       closeButton = TRUE,
                       type = "error")
    }
      
    output$solucion <- renderDataTable(
      datatable(solution,
                filter = "none",
                options = list(
                  dom = "t",
                  searching = F
                ),
                rownames = T))

    output$ValorObj <- renderValueBox(
      valueBox(
        subtitle = i18n$t("El Valor Objetivo "),
        ValObj,
        color = "green",
        icon = icon("check")))

  }else if(input$dir == 1 && input$tipo == 2){ #Problema con transbordo + maximizar
    
    req(iv$is_valid())
    
    transporte <- lp.transport(cost.mat=f.cost(), direction = "max", row.signs=f.row.dir(), row.rhs=f.row.rhs_1(), col.signs=f.col.dir(), col.rhs=f.col.rhs_1(), integers=NULL)
    solution <- as.data.frame(transporte$solution)
    rownames(solution) <- paste0(i18n$t("Origen: "), letters[1:nrow(solution)])
    colnames(solution) <- paste0(i18n$t("Destino: "),letters[1:ncol(solution)])

    ValObj <- transporte$objval
    diag(solution) <- 0
    
    if(ValObj == 0){ #Se muestra la notificación en el caso que el problema no esté balanceado
      showNotification(i18n$t("El problema no está balanceado"),
                       duration = 10, 
                       closeButton = TRUE,
                       type = "error")
    }
    
    output$solucion <- renderDataTable(
      datatable(solution,
                filter = "none",
                options = list(
                  dom = "t",
                  searching = F
                ),
                rownames = T))

    output$ValorObj <- renderValueBox(
      valueBox(
        subtitle = i18n$t("El Valor Objetivo "),
        ValObj,
        color = "green",
        icon = icon("check")))

  }else if(input$dir == 2 && input$tipo == 3){ #Problema de asignacion + minimizar
    
    asignacion <- lp.assign(cost.mat = f.cost(), direction = "min")
    solution <- as.data.frame(asignacion$solution)
    rownames(solution) <- paste0(i18n$t("Origen: "), letters[1:nrow(solution)])
    colnames(solution) <- paste0(i18n$t("Destino: "), letters[1:ncol(solution)])

    ValObj <- asignacion$objval

    if(ValObj == 0){ #Se muestra la notificación en el caso que el problema no esté balanceado
      showNotification(i18n$t("El problema no está balanceado"),
                       duration = 10, 
                       closeButton = TRUE,
                       type = "error")
    }
    
    output$solucion <- renderDataTable(
      datatable(solution,
                rownames = T,
                filter = "none",
                options = list(
                  dom = "t",
                  searching = F
                )))

    output$ValorObj <- renderValueBox(
      valueBox(
        subtitle = i18n$t("El Valor Objetivo "),
        ValObj,
        color = "green",
        icon = icon("check")))

  }else if(input$dir == 1 && input$tipo == 3){ #Problema de asignacion + maximizar
    
    asignacion <- lp.assign(cost.mat = f.cost(), direction = "max")
    solution <- as.data.frame(asignacion$solution)
    rownames(solution) <- paste0(i18n$t("Origen: "), letters[1:nrow(solution)])
    colnames(solution) <- paste0(i18n$t("Destino: "),letters[1:ncol(solution)])

    ValObj <- asignacion$objval

    if(ValObj == 0){ #Se muestra la notificación en el caso que el problema no esté balanceado
      showNotification(i18n$t("El problema no está balanceado"),
                       duration = 10, 
                       closeButton = TRUE,
                       type = "error")
    }
    
    output$solucion <- renderDataTable(
      datatable(solution,
                filter = "none",
                options = list(
                  dom = "t",
                  searching = F
                ),
                rownames = T))

    output$ValorObj <- renderValueBox(
      valueBox(
        subtitle = i18n$t("El Valor Objetivo "),
        ValObj,
        color = "green",
        icon = icon("check")))

  
  }   
})
