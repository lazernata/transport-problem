siderBarPanel <- function(){
  dashboardSidebar(
    usei18n(i18n),
    width = 280,
    sidebarMenu(id="sbmenu",
                menuItem(i18n$t("El Problema de Transporte"), tabName = "principal", icon = icon("arrow-right")),
                menuItem(i18n$t("Guía"), tabName = "guion", icon = icon("question")),
                menuItem(i18n$t("Descripción del Shiny"), tabName = "informacion", icon = icon("info")),
                selectInput('selected_language',
                            i18n$t("Cambiar el idioma"),
                            choices = i18n$get_languages(),
                            selected = i18n$get_key_translation())
    )
  )
}
