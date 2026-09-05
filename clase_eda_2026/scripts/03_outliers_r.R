# 03_outliers_r.R

library(tidyverse)
library(here)

# Cargar datos imputados, utilizaremos MICE
datos <- readRDS(here("data/datos_mice.rds"))

cat("=== DETECCION Y TRATAMIENTO DE OULTIERS ===\\n\n")
detectar_outliers_iqr <- function(x){
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 *IQR
  upper_bound <- Q3 + 1.5 *IQR
  
  return(x < lower_bound | x > upper_bound)
}

# Detectar oultiers en ingreso
outliers_ingreso <- detectar_outliers_iqr(datos$ingreso)
cat("Outliers detectados en ingreso:", sum(outliers_ingreso), "\n")

# Función de winsorización
winsorizar <- function(x, lower_percentile = 0.05, upper_percentile = 0.95) {
  lower <- quantile(x, lower_percentile, na.rm = TRUE)
  upper <- quantile(x, upper_percentile, na.rm = TRUE)
  x[x < lower] <- lower
  x[x > upper] <- upper
  
  return(x)
}

# Aplicar winsorización a Ingreso
datos_winsor <- datos
datos_winsor$Ingreso <- winsorizar(datos_winsor$ingreso)

saveRDS(datos_winsor, here("data/datos_winsor.rds"))

cat(" Winsorizaciónaplicada\n")
cat("  - Estadísticas antes:\n")
print(summary(datos$ingreso))
cat("\n  - Estadísticos después:\n")
print(summary(datos_winsor$ingreso))