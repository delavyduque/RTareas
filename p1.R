pos <- 0
maximun <- 0
dur <- 15
for (t in 1:dur) {
  v <- runif(1) 
  if (v < 0.5) {
    pos <- pos + 1
  } else {
    pos <- pos - 1 
  }
  dist <- abs(pos)
  if (dist > maximun){
	maximun <- dist
  }
}

  print(maximun)
