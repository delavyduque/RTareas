library(parallel)
suppressMessages(library("sna"))
unlink("*.png")
dim <- 50
num <- dim^2
probability <- 0.1
semillas <- 8
tasa <- 1

paso <- function(pos) {
    fila <- floor((pos - 1) / dim) + 1
    columna <- ((pos - 1) %% dim) + 1
    if (actual[fila, columna] > 0){
      vecindad <-  actual[max(fila - 1, 1) : min(fila + 1, dim),
                          max(columna - 1, 1): min(columna + 1, dim)]
      lugaresCero <- which(vecindad == 0)
      if(length(lugaresCero) > 0){
        crecer <- sample(1:length(lugaresCero), tasa)
        for (i in crecer) {
          actual[i] <- actual[fila, columna]
        }
      }
      return vecindad
    }
}

random <- sample(1:2500, semillas, replace=F)
actual <- matrix(0, nrow=dim, ncol=dim)
for (i in 1:semillas) {
  actual[random[i]] <- i/semillas
  print(actual[random[i]])
}
