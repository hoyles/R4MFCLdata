formatwf <- function(dat,fd,minsize=1,binwidth=1,nbins=200) {
  szbins <- seq(minsize,by=binwidth,length.out=nbins)
  wtbin <- binwidth * floor(dat$wt/binwidth)
  times <- dat$yr + switch(fd$fdx$tstrat,(dat$mon)/100,(dat$qtr-0.5)/4)
  sz <- tapply(dat$freq,list(times,factor(wtbin,levels=szbins)),sum)
  sz[is.na(sz)] <- 0
  return(sz)
  }

