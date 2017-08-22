library(parallel)
suppressMessages(library("sna"))
unlink("reto1*.png")
dim <- 50
num <- dim^2
semillas <- 8
ciclo <-0

random <- sample(1:num, semillas, replace=F)
actual <- matrix(0, nrow=dim, ncol=dim)
for (i in 1:semillas) {
  actual[random[i]] <- i/semillas
}

paso <- function(pos) {
  fila <- floor((pos - 1) / dim) + 1
  columna <- ((pos - 1) %% dim) + 1
  if (actual[fila, columna] > 0){
    return(actual[fila, columna])
  } else {
    vecindad <- actual[
      max(fila - 1, 1) : min(fila + 1, dim),
      max(columna - 1, 1): min(columna + 1, dim)
    ]
    lugaresSemilla <- which(vecindad != 0)
    if(length(lugaresSemilla) > 0){
      crecer <- sample(lugaresSemilla, 1)
      return(vecindad[crecer])
    }else {
      return(actual[fila, columna])
    }
  }
}

cluster <- makeCluster(detectCores() - 1)
clusterExport(cluster, "dim")


while(any(actual == 0)){
  clusterExport(cluster, "actual")
  salida = paste("reto1-paso", ciclo ,".png", sep="")
  png(salida)
  plot.sociomatrix(actual, drawlab=F, diaglab=F,  drawlines=T, main=paste("Paso", ciclo))
  graphics.off()
  siguiente <- parSapply(cluster, 1:num, paso)
  actual <- matrix(siguiente, nrow=dim, ncol= dim, byrow= T)
  ciclo <- ciclo + 1
}
actual[1] <-0
salida = paste("reto1-paso", ciclo ,".png", sep="")
png(salida)
plot.sociomatrix(actual, drawlab=F, diaglab=F,  drawlines=T, main=paste("Paso", ciclo))
graphics.off()
stopCluster(cluster)
