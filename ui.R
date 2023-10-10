i18n <- Translator$new(translation_json_path = "data/translation.json")
i18n$set_translation_language("es") # here you select the default translation to display

# choices_select <- c("")

ui_elements <- list.files(file.path(path,"ui_elements"), include.dirs = T, recursive = T, full.names = T, pattern = "\\.R$")

for (functions in ui_elements) {
  try(source(functions, local = T))
}
usei18n(i18n)

# Define UI for application
shinyUI(dashboardPage(skin = "green",
                      dashboardHeader(
                        title = i18n$t("El Problema de Transporte"),
                        titleWidth = 280,
                        tags$li(class = "dropdown",
                                tags$a(href="https://www.ujaen.es/", target="_blank", 
                                       tags$img(height = "20px", alt="Icono Header", src="IconoHeader.png")
                                )
                        )
                      ),
                      
                      siderBarPanel(),
                      bodyPanel()
)
)
