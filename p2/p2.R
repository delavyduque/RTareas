library(parallel)
dim <- 10
num <-  dim^2
random <- runif(num)
probability <- 0.3
actual <- matrix((random < probability)* 1, nrow=dim, ncol=dim)
ciclo <- 0

suppressMessages(library("sna"))
png("p2_t0.png")
plot.sociomatrix(actual, diaglab=FALSE, main="Inicio")
graphics.off()

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

while (sum(actual) > 0){
  ciclo <- ciclo + 1
  clusterExport(cluster, "actual")
  siguiente <- parSapply(cluster, 1:num, paso)
  actual <- matrix(siguiente, nrow=dim, ncol=dim, byrow=TRUE)

  if (sum(actual) > 0){
    salida = paste("p2_t", ciclo ,".png", sep="")
    tiempo = paste("Paso", ciclo)
    png(salida)
    plot.sociomatrix(actual, diaglab=FALSE, main=tiempo)
    graphics.off()
  }
}
stopCluster(cluster)
