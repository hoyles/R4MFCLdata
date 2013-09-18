getce <- function(fd,indat=indat) {
  dd <- NULL
  j <- k <- dim(fd$f_locs)
  for(i in 1:k[1]) {
    dat <- getcedat(fd,indat,i)
    if(length(dat$time) > 0) dat <- aggregate(cbind(catch,effort,badeffort) ~ time + yy, data=dat, sum)
    if(!is.null(dd)) dd <- rbind(dd,dat) else dd <- dat
    }
  if(length(dd$time) > 0) {
    fishce <- aggregate(cbind(catch,effort,badeffort) ~ time + yy,data=dd,sum)
#    fishce$effort[fishce$badeffort > 0] <- 0
    fishce$badeffort <- NULL
    fishce$catch <- round(fishce$catch,1)
    fishce$effort <- round(fishce$effort,0)
    fishce$f <- fd$fdx$fishery_no
    return(fishce)
    } else return(NULL)
  }
