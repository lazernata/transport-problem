informacion <- function(){
  tabItem("informacion",
          fluidRow(
            column(
              width = 12,
              align = "center",
              h4(i18n$t("Este Shiny app ha sido elaborado por "), a("Natalia Lazareva", 
          href = "https://www.linkedin.com/in/lazernatalia/"), 
          i18n$t(", estudiante del Grado en Estadística y Empresa de la Universidad de Jaén como parte del Trabajo Fin de Grado del curso 2022-23. El tutor académico: María Virtudes Alba Fernandez")),
          img(src = "IconoHeader.png", width = 175, height = 125),
            )
          ))}