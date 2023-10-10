server_functions <- list.files(file.path(path,"server_functions"), include.dirs = T, recursive = T, full.names = T, pattern = "\\.R$")

source(file.path(path,"global.R"), local = F)

shinyServer(function(input, output, session) {
  
  # Se cargan el resto de script
  for (functions in server_functions) {
    try(source(functions, local = T))
  }

  
})
