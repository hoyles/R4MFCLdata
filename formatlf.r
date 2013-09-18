formatlf <- function(dat,fd,minsize=10,binwidth=2,nbins=95) {
  szbins <- seq(minsize,by=binwidth,length.out=nbins)
  lenbin <- binwidth * floor(dat$len/binwidth)
  times <- dat$yr + switch(fd$fdx$tstrat,(dat$mon)/100,(dat$qtr-0.5)/4)
  sz <- tapply(dat$freq,list(times,factor(lenbin,levels=szbins)),sum)
  sz[is.na(sz)] <- 0
  return(sz)
  }

