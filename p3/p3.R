suppressMessages(library(doParallel))

primo <- function(n) {
    if (n == 1 || n == 2) {
        return(TRUE)
    }
    if (n %% 2 == 0) {
        return(FALSE)
    }
    for (i in seq(3, max(3, ceiling(sqrt(n))), 2)) {
        if ((n %% i) == 0) {
            return(FALSE)
        }
    }
    return(TRUE)
}

desde <- 1000
hasta <-  3000
original <- desde:hasta
invertido <- hasta:desde
replicas <- 10
datosO <-data.frame()
datosI <-data.frame()
datosA <-data.frame()
coresTotales <- detectCores()
coresRecorridos <- 1

while (coresRecorridos <= coresTotales) {
  cluster <-(makeCluster(coresRecorridos))
  registerDoParallel(cluster)
  ot <-  numeric()
  it <-  numeric()
  at <-  numeric()
  for (r in 1:replicas) {
      ot <- c(ot, system.time(foreach(n = original, .combine=c) %dopar% primo(n))[3]) # de menor a mayor
      it <- c(it, system.time(foreach(n = invertido, .combine=c) %dopar% primo(n))[3]) # de mayor a menor
      at <- c(at, system.time(foreach(n = sample(original), .combine=c) %dopar% primo(n))[3]) # orden aleatorio
  }

  stopImplicitCluster()
  stopCluster(cluster)
  print(coresRecorridos)
  print(summary(ot))
  print(summary(it))
  print(summary(at))

  datosO<- rbind(datosO, c(coresRecorridos, ot))
  datosI<- rbind(datosI, c(coresRecorridos, it))
  datosA<- rbind(datosA, c(coresRecorridos, at))

  coresRecorridos <- coresRecorridos + 1
}

png("Tiempopornucleo_ordenado.png")
boxplot(data.matrix(datosO), xlab = "N\u{FA}cleos", ylab = "Tiempo", main = "Orden de menor a mayor", use.cols=FALSE, ylim = c(0.3, 1.2))
graphics.off()

png("Tiempopornucleo_invertido.png")
boxplot(data.matrix(datosI), xlab = "N\u{FA}cleos", ylab = "Tiempo", main = "Orden de mayor a menor", use.cols=FALSE, ylim = c(0.3, 1.2))
graphics.off()

png("Tiempopornucleo_aleatorio.png")
boxplot(data.matrix(datosA), xlab = "N\u{FA}cleos", ylab = "Tiempo", main = "Orden aleatorio", use.cols=FALSE, ylim = c(0.3, 1.2))
graphics.off()
