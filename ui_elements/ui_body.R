# ljd <- get("ljd", envir = app_envir)
jsResetCode <- "shinyjs.pageCol = function() {history.go(0)}"

bodyPanel <- function(){
  dashboardBody(
    useShinyjs(),
    extendShinyjs(text = jsResetCode, functions = "pageCol"),
    tags$link(rel = "stylesheet", type = "text/css", href="index.css"),
    tabItems(
      principal(),
      guion(),
      informacion()
    )
  )
  
}
