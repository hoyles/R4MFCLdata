build_matrix <- function(fishdefs,amodel,lfd,wtd,lf_minsize,lf_binwidth,lf_nbins,wt_minsize,wt_binwidth,wt_nbins) {
  m <- NULL
  for(i in 1:fishdefs$nfish) {
    fd <- fishdefs[[i]]
    f_ce <- getce(fishdefs[[i]],amodel)   # catch data
    f_lf2 <- NULL
    if(fd$fdx$lf_wf != 2) {
      f_lf <- getsz(fishdefs[[i]],lfd)    # get LF data
      f_lf2 <- formatlf(f_lf,fd,minsize=lf_minsize,binwidth=lf_binwidth,nbins=lf_nbins)  # format the LF data
      }
    f_wf2 <- NULL
    if(fd$fdx$lf_wf != 1 & wt_nbins > 0) {
      f_wf <- getsz(fishdefs[[i]],wtd)                        # get the wt freq data
      f_wf2 <- formatwf(f_wf,fd,minsize=wt_minsize,binwidth=wt_binwidth,nbins=wt_nbins)  # format the wt freq data
      }
    a <- make_mfcl(f_ce,f_lf2,f_wf2,lf_nbins,wt_nbins,fd)
    m <- rbind(m,a)
    print(i); flush.console()
    }
  return(m)
  }
