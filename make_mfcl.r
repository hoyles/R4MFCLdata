make_mfcl <- function(f_ce,f_lf2,f_wf2,nlf,nwf,fd) {
  m <- matrix(0.00,nrow=length(f_ce$yy),ncol=6 + nlf + nwf)
  m[,1] <- f_ce$yy
  m[,2] <- c(2,5,8,11)[f_ce$time]
  if(fd$fdx$tstrat==1) m[,2] <- f_ce$time
  m[,3] <- 1
  m[,4] <- f_ce$f
  m[,5] <- f_ce$catch
  m[,6] <- f_ce$effort
  lfrange <- 7:(6+ nlf)
  wfrange <- (max(lfrange)+1):(max(lfrange) + nwf)
  mtime <- m[,1] + switch(fd$fdx$tstrat,c((1:12)/100)[f_ce$time],c(0.125,0.375,0.625,0.875)[f_ce$time])
  matches <- match(mtime,rownames(f_lf2))
  if(!is.null(f_lf2)) m[,lfrange] <- f_lf2[matches,]
  if(nwf > 0) {
    matches <- match(mtime,rownames(f_wf2))
    if(!is.null(f_wf2)) m[,wfrange] <- f_wf2[matches,]
    }
  m[is.na(m)] <- 0
  # check for no data and set to -1
  if(nwf > 0) wfsum <- apply(m[,wfrange],1,sum)
  lfsum <- apply(m[,lfrange],1,sum)
  if(nwf > 0) m[wfsum==0,min(wfrange)] <- -1
  m[lfsum==0,min(lfrange)] <- -1
  if(nwf > 0) {
    m[lfsum==0,wfrange - min(wfrange) + 8] <- m[lfsum==0,wfrange]
    m[lfsum==0,(max(wfrange - min(wfrange) + 8)+1):dim(m)[2]] <- 0
    } else {
    m[lfsum==0,min(lfrange+1):max(lfrange)]  <- 0
    }
  return(m)
}

