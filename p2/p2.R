library(parallel)
suppressMessages(library("sna"))
unlink("*.png")
dim <- 10
num <- dim^2
probability <- 0.1
df <- data.frame() #saber repeticiones

paso <- function(pos) {
    fila <- floor((pos - 1) / dim) + 1
    columna <- ((pos - 1) %% dim) + 1
    vecindad <-  actual[max(fila - 1, 1) : min(fila + 1, dim),
                        max(columna - 1, 1): min(columna + 1, dim)]
    return(1 * ((sum(vecindad) - actual[fila, columna]) == 3))
}

cluster <- makeCluster(detectCores() - 1)
clusterExport(cluster, "dim")
clusterExport(cluster, "paso")

while (probability <= 0.9) {
  ciclo <- 0
  random <- runif(num)
  actual <- matrix((random < probability)* 1, nrow=dim, ncol=dim)
  salida = paste("p2", probability, ciclo ,".png", sep="")
  png(salida)
  plot.sociomatrix(actual, diaglab=FALSE, main=paste("Inicio", probability))
  graphics.off()

  while (sum(actual) > 0 && sum(actual) < num){
    ciclo <- ciclo + 1
    clusterExport(cluster, "actual")
    siguiente <- parSapply(cluster, 1:num, paso)
    actual <- matrix(siguiente, nrow=dim, ncol=dim, byrow=TRUE)

    if (sum(actual) > 0 && sum(actual) < num){
      salida = paste("p2", probability, ciclo ,".png", sep="")
      tiempo = paste("Generaci\u{F3}n", ciclo, "Probabilidad", probability)
      png(salida)
      plot.sociomatrix(actual, diaglab=FALSE, main=tiempo)
      graphics.off()
    }
  }
  cicloTotal <- ciclo
  probabilidadTotal <-probability
  df <- rbind(df, c(probabilidadTotal, cicloTotal))
  probability <- probability + 0.1
  ciclo <- 0
}

stopCluster(cluster)

png("p2generacionesYprobabilidad.png")
plot(data.matrix(df),
xlab="Probabilidad", ylab="Generaciones", main="Generaciones generadas por probabilidad")
axis(1,at=data.matrix(df)[,1])
graphics.off()
