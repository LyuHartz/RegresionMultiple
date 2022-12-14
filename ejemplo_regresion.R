# Ejemplo 1. Regresión Lineal Múltiple

# Predecir el precio de cena (platillo). 
# Datos de encuestas de clientes de 168 restaurantes Italianos
# en el área deseada están disponibles.

# Y: Price (Precio): el precio (en USD) de la cena
# X1: Food: Valuación del cliente de la comida (sacado de 30)
# X2: Décor: Valuación del cliente de la decoración (sacado de 30)
# X3: Service: Valuación del cliente del servicio (sacado de 30)
# X4: East: variable dummy: 1 (0) si el restaurante está al este (oeste) de la quinta avenida

# Primero debemos establecer nuestro directorio de trabajo y el archivo
# de datos (nyc.csv) que importaremos a R deberá de estar en este directorio

nyc <- read.csv("nyc.csv", header = TRUE)

# Observamos algunas filas y la dimensión del data frame

tail(nyc, 2) 
dim(nyc)
attach(nyc)

# Acontinuación mostramos una matriz de gráficos de dispersión de los
# tres predictores continuos y la variable de respuesta. 

pairs(~ Price + Food + Decor + Service, data = nyc, gap = 0.4, cex.labels = 1.5)

# Observamos relaciones aproximadamente lineales

# Llevamos a cabo el ajuste de un modelo
# Y = beta0 + beta1*Food + beta2*Decor + beta3*Service + beta4*East + e

m1 <- lm(Price ~ Food + Decor + Service + East)

# Obtenemos un resumen

summary(m1)

# Ajustamos nuevamente un modelo pero ahora sin considerar la variable Service
# ya que en el resultado anterior se observó que su coeficiente de regresión
# no fue estadísticamente significativo (al considerar su p-value)

# Y = beta0 + beta1*Food + beta2*Decor + beta4*East + e (Reducido)

m2 <- lm(Price ~ Food + Decor + East)

# Obtenemos un resumen del modelo ajustado

summary(m2)

# Una forma alternativa de obtener m2 es usar el comando update

m2 <- update(m1, ~.-Service)
summary(m2)

######

# Análisis de covarianza

# Para investigar si el efecto de los predictores depende de la variable dummy 
# East consideraremos el siguiente modelo el cual es una extensión a más de una 
# variable predictora del modelo de rectas de regresión no relacionadas 
# Y = beta0 + beta1*Food + beta2*Decor +  beta3*Service + beta4*East 
#           + beta5*Food*East + beta6*Decor*East + beta7*Service*East + e (Completo)

mfull <- lm(Price ~ Food + Decor + Service + East + 
              Food:East + Decor:East + Service:East)

# Note como ninguno de los coeficientes de regresión para los
# términos de interacción son estadísticamente significativos

summary(mfull)

# Ahora compararemos el modelo completo guardado en mfull contra el modelo
# reducido guardado en m2. Es decir, llevaremos a cabo una prueba de hipótesis
# general de

# H0: beta3 = beta5 = beta6 = beta7 = 0
# es decir Y = beta0 + beta1*Food + beta2*Decor + beta4*East + e (Reducido)
# contra
# H1: H0 no es verdad
# es decir, 
# Y = beta0 + beta1*Food + beta2*Decor +  beta3*Service + beta4*East 
#           + beta5*Food*East + beta6*Decor*East + beta7*Service*East + e (Completo)

# La prueba de si el efecto de los predictores depende de la variable dummy
# East puede lograrse usando la siguiente prueba-F parcial.

anova(m2,mfull)

# Dado que el p-value es aproximadamente 0.36, fallamos en rechazar la hipótesis
# nula y adopatamos el modelo reducido
# Y = beta0 + beta1*Food + beta2*Decor + beta4*East + e (Reducido)

######

# Diagnósticos

# En regresión múltiple, las gráficas de residuales o de residuales
# estandarizados proporcionan información directa sobre la forma
# en la cual el modelo está mal especificado cuando se cumplen
# las siguientes dos condiciones:

# E(Y | X = x) = g(beta0 + beta1*x1 + ... + betap*xp) y
# E(Xi | Xj) aprox alpha0 + alpha1*Xj

# Cuando estas condiciones se cumplen, la gráfica de Y contra
# los valores ajustados, proporciona información directa acerca de g.
# En regresión lineal múltiple g es la función identidad. En
# este caso la gráfica de Y contra los valores ajustados
# debe producir puntos dispersos alrededor de una recta.
# Si las condiciones no se cumplen, entonces un patrón en la
# gráfica de los residuales indica que un modelo incorrecto
# ha sido ajustado, pero el patrón mismo no proporciona 
# información directa sobre como el modelo está mal específicado.

# Ahora tratemos de verificar si el modelo ajustado es un modelo válido.

summary(m2)

# Mostramos una gráfica de Y, el precio contra los valores
# ajustados 

plot(m2$fitted.values, Price, xlab = "Valores ajustados", ylab = "Price")
abline(lsfit(m2$fitted.values, Price))

# Acontinuación mostramos una matriz de gráficos de dispersión de los
# dos predictores continuos. Los predictores parecen estar linealmente
# relacionados al menos aproximadamente

pairs(~ Food + Decor, data = nyc, gap = 0.4, cex.labels = 1.5)


# Acontinuación veremos gráficas de residuales estandarizados contra cada
# predictor. La naturaleza aleatoria de estas gráficas es un indicativo de
# que el modelo ajustado es un modelo válido para los datos.

StanRes2 <- rstandard(m2)
par(mfrow = c(2, 2))
plot(Food, StanRes2, ylab = "Residuales Estandarizados")
plot(Decor, StanRes2, ylab = "Residuales Estandarizados")
plot(East, StanRes2, ylab = "Residuales Estandarizados")

# Buscamos evidencia para soportar la supocisión de normalidad en los errores 

qqnorm(StanRes2)
qqline(StanRes2)

# Inspirado en:


