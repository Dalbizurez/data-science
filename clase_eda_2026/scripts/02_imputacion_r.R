#02_imputacion_r.R

library(tidyverse)
library(mice)
library(naniar)
library(here)

# Cargar datos
datos <- readRDS(here("data/datos_raw.rds"))

cat("=== IMPUTACIÓN DE VALORES FALTANTES ===\n\n")

# 1. Imputación por mediana
cat("1. Imputación por mediana...\n")

datos_median <- datos
for(col in names(datos_median)){
  if(is.numeric(datos_median[[col]])){
    datos_median[[col]][is.na(datos_median[[col]])] <- median(datos_median[[col]], na.rm = TRUE)
  
  }
}

saveRDS(datos_median, here("data/datos_median.rds"))
cat(" Completado")

# 2. Imputacion por regresión

cat("2. Imputación por regresión")
datos_regresion <- datos
modelo_edad <- lm(edad ~ ingreso + educacion + experiencia, datos)
indices_na_edad <- which(is_na(datos_regresion$edad))

if(length(indices_na_edad)>0) {
  datos_regresion$edad[indices_na_edad] <- predict(modelo_edad, newdata = datos_regresion[indices_na_edad,])
}

saveRDS(datos_median, here('data/datos_regresion.rds'))
cat(" Completado\n")

# 3. Imputacion por MICE
imputaciones <- mice(datos, m=5, method='pmm', maxit=50, seed = 123)

datos_mice <- complete(imputaciones, 1)
saveRDS(datos_mice, here('data/datos_mice.rds'))
cat(" Completado\n")

cat(" Todas las imputaciones se han completado\n")
