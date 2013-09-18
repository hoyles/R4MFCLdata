# 



#getce <- function(fd,indat=indat) {
#  f_locs <- fd$f_locs
#  f_gear_list <- fd$gear_list
#  f_flag_list <- fd$flag_list
#  f_fleet_list <- "*"
#  f_sch_id_list <- fd$sch_id_list
#  dd <- NULL
#  j <- k <- dim(f_locs)
#  if(is.null(k)) { 
#    k <- 1
#    fl <- f_locs
#    fid <- f_locid
#    } 
#  for(i in 1:k[1]) {
#    if(!is.null(j)) fl <- as.numeric(f_locs[i,])
#    dat <- indat[indat$minlong < fl[4] & indat$maxlong > fl[3] & indat$minlat < fl[2] & indat$maxlat > fl[1],]
#    if(f_gear_list[1] != "*") dat <- dat[dat$gr_id %in% f_gear_list,]
#    dat$flagfleet <- paste(dat$flag_id,dat$fleet_id,sep="")
#    if(f_flag_list[1] != "*") dat <- dat[dat$flag_id %in% f_flag_list | dat$flagfleet %in% f_flag_list,]
#    if(f_sch_id_list[1] != "*") dat <- dat[dat$sch_id %in% f_sch_id_list,]
#    a <- dat[dat$gr_id=="S",] 
#    dat[dat$gr_id=="S","effort"] <- switch(as.character(fd$fdx$effort),H=a$hhooks,E=a$stdeff,D=a$stdeff,S=a$stdeff,X=0)
#    a <- dat[dat$gr_id!="S",] 
#    dat[dat$gr_id!="S", "effort"] <- switch(as.character(fd$fdx$effort),H=a$hhooks,E=a$stdeff,D=a$days,S=a$sets,X=0)
#    spcatch <- paste(fd$fdx$sp_id,fd$fdx$catch,sep="")
#    dat$catch <- switch(spcatch,BET1=dat$bet_n,BET2=dat$bet_c,YFT1=dat$yft_n,YFT2=dat$yft_c,SKJ1=dat$skj_n,SKJ2=dat$skj_c,ALB1=dat$alb_n,ALB2=dat$alb_c)
#    dat$catch_n <- switch(fd$fdx$sp_id,BET=dat$bet_n,YFT=dat$yft_n,SKJ=dat$skj_n,ALB=dat$alb_n)
#    if(length(dat$effort) > 0) {
#      dat$badeffort <- 0
#      dat$badeffort[dat$effort<=0 & dat$catch_n > 10] <- 1
#      }
#    dat$qtr <- floor((dat$mm-1)/3)+1
#    if(length(dat$qtr) > 0) dat <- aggregate(cbind(catch,effort,badeffort) ~ qtr + yy, data=dat, sum)
#    if(!is.null(dd)) dd <- rbind(dd,dat) else dd <- dat
#    }  
#  if(length(dd$qtr) > 0) {
#    fishce <- aggregate(cbind(catch,effort,badeffort) ~ qtr + yy,data=dd,sum)
##    fishce$effort[fishce$badeffort > 0] <- 0
#    fishce$badeffort <- NULL
#    fishce$catch <- round(fishce$catch,1)
#    fishce$effort <- round(fishce$effort,0)
#    fishce$f <- fd$fdx$fishery_no
#    return(fishce)
#    } else return(NULL)
#  } 



