getcedat <- function(fd,indat,i) {
  f_locs <- fd$f_locs
  f_gear_list <- fd$gear_list
  f_flag_list <- fd$flag_list
  f_fleet_list <- "*"
  f_sch_id_list <- fd$sch_id_list
  fl <- as.numeric(f_locs[i,])
  dat <- indat[indat$minlong < fl[4] & indat$maxlong > fl[3] & indat$minlat < fl[2] & indat$maxlat > fl[1],]
  if(f_gear_list[1] != "*") dat <- dat[dat$gr_id %in% f_gear_list,]
  dat$flagfleet <- paste(dat$flag_id,dat$fleet_id,sep="")
  if(f_flag_list[1] != "*") dat <- dat[dat$flag_id %in% f_flag_list | dat$flagfleet %in% f_flag_list,]
  if(f_sch_id_list[1] != "*") dat <- dat[dat$sch_id %in% f_sch_id_list,]
  a <- dat[dat$gr_id=="S",]
  dat[dat$gr_id=="S","effort"] <- switch(as.character(fd$fdx$effort),H=a$hhooks,E=a$stdeff,D=a$stdeff,S=a$stdeff,X=0)
  a <- dat[dat$gr_id!="S",]
  dat[dat$gr_id!="S", "effort"] <- switch(as.character(fd$fdx$effort),H=a$hhooks,E=a$stdeff,D=a$days,S=a$sets,X=0)
  spcatch <- paste(fd$fdx$sp_id,fd$fdx$catch,sep="")
  dat$catch <- switch(spcatch,BET1=dat$bet_n,BET2=dat$bet_c,YFT1=dat$yft_n,YFT2=dat$yft_c,SKJ1=dat$skj_n,SKJ2=dat$skj_c,ALB1=dat$alb_n,ALB2=dat$alb_c)
  dat$catch_n <- switch(fd$fdx$sp_id,BET=dat$bet_n,YFT=dat$yft_n,SKJ=dat$skj_n,ALB=dat$alb_n)
  if(length(dat$effort) > 0) {
    dat$badeffort <- 0
    dat$badeffort[dat$effort<=0 & dat$catch_n > 1] <- 1
    }
  dat$time <- switch(fd$fdx$tstrat,dat$mm,floor((dat$mm-1)/3)+1)
  return(dat)
  }

