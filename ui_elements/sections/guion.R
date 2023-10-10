guion <- function(){
  tabItem("guion",
          tabsetPanel(type = "tabs", 
            tabPanel(i18n$t("Las Instrucciones"),
                               br(),
          fluidRow(
            column(width = 12,
              helpText(h3(i18n$t("Pasos a seguir:")),
                       i18n$t("1. Seleccione el número de filas (origenes) y el número de columnas (destinos) del problema."),
                       br(),
                       br(),
                       i18n$t("2. Seleccione el tipo del problema:"), em(i18n$t("El problema de transporte, el problema de transporte con transbordo, el problema de asignación.")),
                       br(),
                       br(),
                       i18n$t("3. Seleccione si es el problema de maximización o minimización. La opción predefinida es "), em(i18n$t("minimizar.")),
                       br(),
                       br(),
                       i18n$t("4. Introduce la matriz de costos del transporte balanceada, las cantidades de la oferta y de la demanda. Deben ser los valores numéricos positivos."),
                       br(),
                       br(),
                       p(i18n$t("5. Introduce las direcciones de las restricciones. Las posibles opciones son: "), ("<=, <, >=, >"))
              )))
            ),
          
             tabPanel(i18n$t("Marco teórico"),
                      br(),
      fluidRow(
        column(6,
               align = "center",
               p(h2(i18n$t("Introducción"))),
               p(em(i18n$t("El problema de transporte o de distribución")),i18n$t(" es un modelo particular del problema de programación lineal, y se refiere a encontrar la forma para minimizar los costos de transporte para la distribución de un bien determinado desde los puntos de abastecimiento, que se llaman orígenes, a los puntos de recepción, que tienen el nombre de destinos. Un caso particular del problema de transporte es"), 
               em(i18n$t("el problema de asignación")),  
               i18n$t(", que consiste en distribuir de forma óptima las tareas a los trabajadores y el problema de transbordo, cuando las mercancías tienen que pasar por los puntos intermedios para llegar a su destino final. Cabe destacar que también tiene unas cuantas aplicaciones no tradicionales. Por ejemplo, los problemas de control de producción y del servicio de afilado de herramientas también pueden ser planteados y resueltos como problemas de transporte."))),
        column(6,
               align = "center",
               p(h2(i18n$t("Origen del problema"))),
               p(i18n$t("El problema del transporte surgió en la Investigación de Operaciones en la década de 1940. Fue planteado por Hitchcock en 1941, luego por Kantorovich y Koopmans. El modelo de Hitchcock trata de encontrar el costo más bajo de enviar productos desde diferentes fábricas a diferentes ciudades. Danzig desarrolló el primer método de programación lineal para resolver este problema en 1951.")),)
    ),
    fluidRow(
      br(),
      column(4,
             align = "center",
             dropdownButton(
               
               tags$h3(i18n$t("El problema de transporte")),
               
               p(i18n$t("- Se puede enviar el producto del origen al destino por un costo determinado.")),
               p(i18n$t("- Se conocen los valores de las cantidades ofertadas y demandadas.")),
               p(i18n$t("- Este problema puede ser resuelto por "), a(i18n$t("el método simplex"), 
                                                              href = "https://www.youtube.com/watch?v=WayFj3NjuVU&ab_channel=estudiia"), 
                 ", ", a(i18n$t("el algoritmo Stepping-Stones"), 
                       href = "https://www.youtube.com/watch?v=XDeRT0PUvFI&ab_channel=Jos%C3%A9Rangel"),
                 ", ", a(i18n$t("el método de la esquina noroeste"), 
                         href = "https://www.youtube.com/watch?v=cGqiHqxKI0w&ab_channel=ProfeCastorena"),
                 i18n$t("o con "), a(i18n$t("el método de Vogel."), 
                       href = "https://www.youtube.com/watch?v=0TpyIG5zj1E&ab_channel=SimplexBorre"),
               ),
               
               circle = TRUE, status = "success",
               icon = icon("truck"), width = "300px"
               
               # tooltip = tooltipOptions(title = i18n$t("El problema de transporte"))
             )),
     column(4,
            align = "center",
            dropdownButton(
              
              tags$h3(i18n$t("El problema de transporte con transbordo")),
              
              p(i18n$t("- Las rutas directas no existen o son costosas.")),
              p(i18n$t("- Resulta necesario hacer un transbordo para realizar la entrega.")),
              p(i18n$t("- El problema con transbordo se resuelve como un problema de transporte habitual.")),
              
              circle = TRUE, status = "success",
              icon = icon("warehouse"), width = "300px"
              
              # tooltip = tooltipOptions(title = i18n$t("El problema de transporte con transbordo"))
            )),
     column(4,
            align = "center",
            dropdownButton(
              
              tags$h3(i18n$t("El problema de asignación")),
              
              p(i18n$t("- Ahora los orígenes son las personas y los destinos son tareas a realizar.")),
              p(i18n$t("- Cada tarea puede ser asignada sólo a un trabajador, y cada trabajador puede hacer sólo una tarea.")),
              p(i18n$t("- Para la solución se utiliza "), a(i18n$t("el método húngaro."), 
                                                    href = "https://www.youtube.com/watch?v=zGqlgOd2B14&ab_channel=RONAGIS")
              ),
              
              circle = TRUE, status = "success",
              icon = icon("tasks"), width = "300px"
              
              # tooltip = tooltipOptions(title = i18n$t("El problema de asignación"))
            )
            )
    ),
    fluidRow(
      br(),
    column(4,
           align = "center",
           img(src = "MC-20.png", width = 320, height = 320),
           p(em(i18n$t("Figura 1: Representación gráfica del problema de transporte")))),
    column(4,
           align = "center",
           img(src = "Sin-título-333.png", width = 320, height = 320),
           p(em(i18n$t("Figura 2: Representación gráfica del problema de transporte con transbordo")))),
    column(4,
           align = "center",
           img(src = "asigancion.jpg", width = 320, height = 320),
           p(em(i18n$t("Figura 3: Representación gráfica del problema de asignación"))))
    )))
  )}