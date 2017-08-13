library(parallel)
repetir <- 1000
pasos <- 500
datos <-  data.frame()
datosPD <- data.frame() #datos de Pasos y Dimensiones
datosNP <- data.frame() #datos sin Paralelismo

experimento <- function(replica) {
  pos <- rep(0, dimension)
  origen <- rep(0, dimension)
  times <-0
  for (t in 1:pasos) {
    cambiar <- sample(1:dimension, 1)
    cambio <- 1
    if (runif(1) < 0.5) {
        cambio <- -1
    }
    pos[cambiar] <- pos[cambiar] + cambio

    if (all(pos == origen)) {
      times <- times + 1
    }
  }
  return(times)
}

cluster <- makeCluster(detectCores() - 1)
clusterExport(cluster, "pasos")

for (dimension in 1:8) {
    clusterExport(cluster, "dimension")
    M <-system.time(resultado <- parSapply(cluster, 1:repetir, experimento))[3] #Con Paralelismo y revisando el tiempo
    N <-system.time(resultado <- sapply(1:repetir, experimento))[3] #Sin paralelismo
    datos <- rbind(datos, resultado)
    datosPD <- rbind(datosPD, M)
    datosNP <- rbind(datosNP, N)
}

stopCluster(cluster)
png("p1er.png")
boxplot(data.matrix(datos), use.cols=FALSE,
xlab="Dimensi\u{F3}n", ylab="Numero de veces que regresa al origen", main="Euclideana")
graphics.off()

png("systemTime.png")
plot(data.matrix(datosPD),
xlab="Dimensiones", ylab="Tiempo", main="Tiempo de ejecucion")
graphics.off()

png("notParalel.png")
plot(data.matrix(datosNP),
xlab="Dimensiones", ylab="Tiempo", main="Tiempo de ejecucion")
graphics.off()
