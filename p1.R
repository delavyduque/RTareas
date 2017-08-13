library(parallel)
repetir <- 100
pasos <- 200
datos <-  data.frame()

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
    resultado <- parSapply(cluster, 1:repetir, experimento)
    datos <- rbind(datos, resultado)
}

stopCluster(cluster)
png("p1er100y200.png")
boxplot(data.matrix(datos), use.cols=FALSE,
xlab="Dimensi\u{F3}n", ylab="Numero de veces que regresa al origen", main="Euclideana")
graphics.off()
