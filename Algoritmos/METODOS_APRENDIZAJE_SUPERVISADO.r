#############################################################################################
#############################################################################################
##  Actividad 2. Aplicacion de tecnicas de aprendizaje supervisado sobre datos biologicos  ##
#############################################################################################
#############################################################################################


#### 1.) Preparación del entorno de trabajo con instalación y carga de paquetes necesarios. ###

rm(list=ls()) # Limpieza del entorno
setwd("C:/Users/laura/Documents/Unir/Algoritmos/Actividad2") # Configuracion del directorio de trabajo
df <- read.csv("data.csv") # Carga y exploracion de datos
str(df)
table(df$Diagnosis) # Crear una tabla de frecuencias de la columna Diagnosis
data <- subset(df, select = 2:32) # Seleccion de variables desde la columna 2 hasta la 32
str(data) # Muestra la estructura de la seleccion

# Lista de paquetes necesarios
packs <- c (
  "glmnet",      # Para realizar el metodo Lasso
  "tidyverse",   # Para la lectura y manipulación de datos, para graficos a través de ggplot2
  "caret",       # Para realizar Machine Learning
  "pROC",        # Para analizar curva ROC
  "PRROC"        # Para grafico curva ROC
  )

# Instalación en CRAN
install.packages(packs, dependencies = TRUE)

# Carga de librerias
library(glmnet)
library(tidyverse)
library(caret)
library(pROC)
library(PRROC)


# Machine learning methods:
names(getModelInfo()) # Visualizacion de todos los algoritmos disponibles en el paquete caret
modelLookup(model = "svmLinear") # Consulta de la ficha tecnica del modelo que se va a utilizar como tecnica de aprendizaje supervisado

# Se guardan los nombres de las columnas donde estan las variables
variables <- names(df[3:32])

# Preparacion de los datos para el modelo LASSO
x <- as.matrix(df[, variables]) # Convertir los datos de los variables en una matriz (necesario para glmnet)
y <- factor(df$Diagnosis) # Definir la variable objetivo como categoria


### 2.) Ajuste del modelo LASSO. ###
set.seed(1995) # Semilla para asegurar que los resultados sean iguales cada vez se emplee el codigo

# Ajuste del modelo LASSO usando validación cruzada (cv) para encontrar el mejor lambda.
lasso_model <- cv.glmnet(x, y, family = "binomial", alpha = 1)

# Extracción de los coeficientes del modelo usando el lambda que dio el menor error (lambda.min).
selected_variables <- coef(lasso_model, s = "lambda.min")
selected_variables <- as.matrix(selected_variables) # Convertir a matriz densa si es necesario (esto convierte el formato disperso a un formato manejable)
selected_variables_df <- as.data.frame(selected_variables) # Convertir la matriz a data frame para facilitar su manipulación
non_zero_indices <- selected_variables_df[selected_variables_df$lambda.min != 0, , drop = FALSE] # Filtrar los coeficientes no cero, los que LASSO considera importantes
dim(non_zero_indices)
non_zero_indices

# Extracción de los codigos de identificacion (ID´s) de las 16 variables seleccionadas por Lasso (se quita "Intercept")
names <- rownames(non_zero_indices)[2:17]
names

# Creación de un nuevo dataset solo con la variable objetivo y las variables seleccionadas por LASSO
data <- df %>% dplyr:: select(Diagnosis, all_of(names))
rows <- df$ID # Se asignan los códigos de muestra como nombres de fila.
rownames(data) <- rows
str(data)

write_csv(data, "data_reducido.csv") # Se guarda este dataset reducido en un archivo CSV.
names <- colnames(data)[-1] # Se reorganizan las columnas para que la variable objetivo este al final.
data <- data %>% dplyr::select(all_of(names), Diagnosis)


### 3.) Division del conjunto de datos en conjuntos de entrenamiento (80%) y prueba (20%) ###
set.seed(1995)
trainIndex <- createDataPartition(data$Diagnosis, p = 0.8, list = FALSE)
data$Diagnosis <- as.factor(data$Diagnosis)
trainData <- data[trainIndex,] # Datos para que el modelo aprenda
testData <- data[-trainIndex,] # Datos para probar el modelo


### 4.) Seleccion y entrenamiento del modelo. ###
# Se escoge Support Vector Machine (SVM) porque los autores indican que la mejor precisión predictiva se obtuvo utilizando un plano de separación lineal
# Se entrena un modelo de SVM lineal creado a partir del paquete caret:
# El parámetro C (cost) por defecto es 1 (pero se puede tunear) y controla la flexibilidad del modelo para encontrar un equilibrio entre un margen amplio y la clasificación correcta de las muestras
svmModelLineal <- train(Diagnosis ~.,
                        data = trainData,
                        method = "svmLinear",
                        trControl = trainControl(method = "cv", number = 10), # Validacion cruzada de 10 pliegues
                        preProcess = c("center", "scale"), # Normalizacion de los datos
                        tuneGrid = expand.grid(C = seq(0, 2, length = 20)), # C grande lleva al sobreajuste, C pequeño al infraajuste. Se realiza prueba con 20 valores diferentes de C (Costo) entre 0 y 2 para ver cual funciona mejor
                        prob.model = TRUE) 
svmModelLineal

plot(svmModelLineal) # Se dibuja un gráfico que muestra la variación de la precisión segun el valor de C

# Calculo de la precisión del modelo en el conjunto de prueba utilizando el modelo entrenado
# Se usa el modelo entrenado para predecir las etiquetas del conjunto de prueba
predictions <- predict(svmModelLineal, newdata = testData )
predictions

# Evaluacion de la precisión del modelo utilizando la matriz de confusión
confusionMatrix(predictions, testData$Diagnosis)

# SVM lineal. Calculo de las probabilidades del modelo de que sea maligno (M) o benigno (B).
probabilities_svm_linear <- predict(svmModelLineal, newdata = testData, type = "prob")
probabilities_svm_linear

# Resultado SVMLinear
# El modelo identifica la clase B (Benigno) como la positiva.
# Muestra 2 casos de falsos positivos, que eran M (Malignos) pero se han predecido como B (Benigno).
# También se han detectado 2 falsos negativos que eran B pero se han predecido como M.
# Se observa una alta sensibilidad (0,9718) y especificidad (0,9524), lo que significa que el modelo tiene una gran capacidad para detectar los casos positivos y negativos.
# Para el valor Accuracy se obtiene un valor de 0,9621, por lo que el modelo tiene un excelente rendimiento y, por lo tanto, un modelo robusto.


### 5.) Curva ROC
roc_svm_linear <- roc(testData$Diagnosis, probabilities_svm_linear[,2], levels=c("B", "M"), direction="<")
auc_svm_linear <- auc(roc_svm_linear)
cat("AUC SVM Lineal:", auc_svm_linear, "\n")
auc_svm_linear

# Grafico de curva ROC
plot(roc_svm_linear, 
     main = "Curva ROC - Modelo SVM Lineal", 
     col = "red",           # Color azul para la línea
     lwd = 3,                   # Grosor de la línea
     print.auc.x = 0.5,         # Posición X del texto AUC
     print.auc.y = 0.4,         # Posición Y del texto AUC
     xlab = "Specificity", 
     ylab = "Sensitivity")

# Se añade legenda al grafico
legend("bottomright", 
       legend = paste0("AUC SVM Linear Test (", round(auc_svm_linear, 4), ")"), 
       col = "red", 
       lwd = 3, 
       bty = "o",
       bg = "white",   # Fondo del recuadro blanco para que sea legible
       box.col = "black",
       cex = 0.5)

# Resultado Curva ROC
# El modelo SVM Lineal alcanzó un AUC de 0,9923 en el conjunto de prueba. Esto demuestra que la combinación de la selección
# de características mediante LASSO y el hiperplano de separación óptimo de SVM permite distinguir las clases con una gran
# precision, garantizando un equilibrio óptimo entre sensibilidad y especificidad.