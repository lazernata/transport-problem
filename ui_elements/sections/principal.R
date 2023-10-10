principal <- function(){
  #Sección proncipal
  tabItem("principal", 
          fluidRow(column(3,
                   align = "center",
              numericInput("rows", h4(i18n$t("Número de filas:")), "2")), #Selección del número de filas
            
            column(3,
                   align = "center",
              numericInput("columns", h4(i18n$t("Número de columnas:")), "2")), #Selección del número de columnas
            
            column(3,
                   align = "center", 
                   uiOutput("problem_select")),
            column(3,
              align = "center", #Selección del tipo de problema
              uiOutput("selector_direction"))),
          
          fluidRow(column(8,
                   align = "center",
                   uiOutput("changing_mat")), #la matriz de costos
                  
            hidden(tags$div(
              id = "ocultar",
                column(2, 
                   align = "center",
                   (uiOutput("signos_of"))), #la matriz de los signos de las filas (ofertas)
            
            column(2,
                   align = "center",
                   (uiOutput("ofertas")))#la matriz de los valores de las ofertas (filas)
              ))
            ), 
          
          hidden(tags$div(
            id = "ocultar1",
            fluidRow(column(8,
                   align = "center",
                   (uiOutput("signos_dem")) #la matriz de los signos de las demandas (columnas)
                   )),
          
          fluidRow(column(8,
                   align = "center",
                   (uiOutput("demandas")) #la matriz de los valores de las demandas (columnas)
                   ))
          )),
          
          br(),
          
          fluidRow(column(12,
                   align = "center",
                   actionBttn(inputId = "sol", #el botón de solución
                              label = i18n$t("Solución"), 
                              style = "jelly",
                              color = "success")),
                   ),
          br(),
          
          fluidRow(column(8,
                   align = "center",
            DT::dataTableOutput("solucion")), #el output de la matriz de asignaciones
            column(4,
                   align = "center",
                   valueBoxOutput("ValorObj", width = 12)) #el output con el valor objetivo
            ),
          )
}