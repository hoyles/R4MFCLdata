clean_locations <- function(dat,strat,standard_areas) {
  dat <- make_locd(dat,strat)
  dat$area_id <- gsub(" ","",as.character(dat$area_id))
  b <- dat$lat_short == "   " & dat$lon_short=="    "
  a <- standard_areas[match(dat[b,"area_id"],standard_areas$area_code),c("minlat","minlong","maxlat","maxlong")]
  dat[b,]$minlat  <- a$minlat
  dat[b,]$minlong  <- a$minlong
  dat[b,]$maxlat  <- a$maxlat
  dat[b,]$maxlong  <- a$maxlong
  dat <- dat[!is.na(dat$minlat),]
  return(dat)
  }

