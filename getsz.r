getsz <- function(fd=fishdefs[[4]],indat=indat) {
  f_locs <- as.matrix(fd$f_locs)
  f_gear_list <- fd$gear_list
  f_flag_list <- fd$flag_list
  f_fleet_list <- "*"
  f_sch_id_list <- fd$sch_id_list
  f_sch_id_list <- f_sch_id_list[!f_sch_id_list==0]              # for size data, unknown school type shouldn't be included
  maxlong <- max(f_locs[,4]); minlong <- min(f_locs[,3]); maxlat <- max(f_locs[,2]); minlat <- min(f_locs[,1]) # broad initial parameters to reduce the number of records tested
  dat <- indat[indat$minlong < maxlong & indat$maxlong > minlong & indat$minlat < maxlat & indat$maxlat > minlat,]
  if(f_gear_list[1] != "*") dat <- dat[dat$gr %in% f_gear_list,]
  dat$flagfleet <- paste(dat$flag_id,dat$fleet_id,sep="")
  if(f_flag_list[1] != "*") dat <- dat[dat$flag_id %in% f_flag_list | dat$flagfleet %in% f_flag_list,]
  if(f_sch_id_list[1] != "*") dat <- dat[dat$sch_id %in% f_sch_id_list,]
  dat <- dat[!dat$origin_id %in% c("TTOB"),]                     # the only origin_id restriction
  if(!is.null(dat$wt) & length(dat$sp_id) > 0) dat$pending <- 0
  dat <- dat[dat$pending==0,]
  dat <- check_distrib(dat,f_locs)
  if(length(dat$sp_id) > 0) dat$f <- fd$fdx$fishery_no
  return(dat)
  }

