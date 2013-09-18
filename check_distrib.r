check_distrib <- function(dat,locs=fishdefs[[4]]$f_locs) {
  ngrid <- dim(locs)[1]
  scores <- array(0,dim=c(length(dat$maxlat),ngrid))
  for(i in 1:ngrid) {
    maxlat <- dat$maxlat; minlat <- dat$minlat; minlong <- dat$minlong; maxlong <- dat$maxlong
    inlat <- apply(cbind(0,apply(cbind(maxlat, locs[i,2]),1,min) - apply(cbind(minlat, locs[i,1]),1,max)),1,max)
    inlon <- apply(cbind(0,apply(cbind(maxlong,locs[i,4]),1,min) - apply(cbind(minlong,locs[i,3]),1,max)),1,max)
    scores[,i] <- (inlat / (maxlat - minlat)) * (inlon / (maxlong - minlong))
    }
  dat <- dat[apply(scores,1,sum) >= 0.75,]
  }


