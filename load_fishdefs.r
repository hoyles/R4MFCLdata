load_fishdefs <- function(fn = "mfd_BET3.csv",sp="BET",scheme_id=3,f_locas=standard_areas) {
  fdx <- read.csv(fn)
  fdx <- fdx[fdx$sp_id == sp & fdx$scheme_id==scheme_id,]
  nfish <- length(fdx$scheme_id)
  fdx <- fdx[order(fdx$fishery_no),]
  fdx$flag_list <-   reform(fdx$flag_list)
  #fdx$fleet_list <-  reform(fdx$fleet_list)
  fdx$gear_list <-   reform(fdx$gear_list)
  fdx$sch_id_list <- reform(fdx$sch_id_list)
  fdx$area_list <-   reform(fdx$area_list)
  fishdefs<- list()
  for(i in 1:nfish) {
    a <- unlist(strsplit(as.character(fdx$area_list[i]),","))
    loc <- pmatch(a,f_locas$area_code)
    flag_list <- unlist(strsplit(as.character(fdx$flag_list[i]),","))
    fleet_list <- unlist(strsplit(as.character(fdx$fleet_list[i]),","))
    gear_list <- unlist(strsplit(as.character(fdx$gear_list[i]),","))
    sch_id_list <- unlist(strsplit(as.character(fdx$sch_id_list[i]),","))
    fishdefs[[i]] <- list(fdx=fdx[i,],f_locs = f_locas[loc,c("minlat","maxlat","minlong","maxlong")],flag_list=flag_list,fleet_list=fleet_list,gear_list=gear_list,sch_id_list=sch_id_list)
    }
  fishdefs$nfish <- nfish
  return(fishdefs)
  }
