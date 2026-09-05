# Crear estructura de carpetas
crear_estructura <- function() {
  carpetas <- c(
    "data",
    "scripts",
    "reports",
    "outputs",
    "outputs/figuras",
    "outputs/tablas"
  )
  
  for (carpeta in carpetas){
    if (!dir.exists(carpeta)){
      dir.create(carpeta, recursive = TRUE)
      cat("carpeta creada:", carpeta, "\n")
    } else {
      cat("carpeta ya existe", carpeta, "\n")
    }
  }
}

crear_estructura()
